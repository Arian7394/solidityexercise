// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.9.0;

/* 
Exercise 1: No loop!
Below is a simple contract for keeping balances and transfer the credits. 
1- Play around with the code, deply the contract and check the gasses when calling transfer function. 
2- Try increasing the number of accounts in the array. Check the gasses. 
3- Can you guess with the current gass limit, what is the maximum array length? 
*/
contract Token_naive {

  address[] public addresses;
  uint[] public balances;
  uint public totalSupply;

  constructor(uint _initialSupply) 
  {
    addresses.push(msg.sender);
    balances.push(_initialSupply);
    totalSupply = _initialSupply;
  }

  function transfer(address _to, uint _value) public returns (bool) 
  {
    bool flag = false;
    bool flag2 = false;
    for (uint i=0; i<addresses.length; i++)
    {
      if(addresses[i] == msg.sender)
      {
        require(balances[i] - _value >= 0);
        balances[i] -= _value;
        flag2 = true;
      }
      if(addresses[i] == _to)
      {
        balances[i] += _value;
        flag = true;
      }
    }
    require(flag2);
    if(!flag)
    {
      addresses.push(_to);
      balances.push(_value);
    }
    return true;
  }

  function balanceOf(address _owner) public view returns (uint balance) 
  {
    for (uint i=0; i<addresses.length; i++)
    {
      if(addresses[i] == _owner)
      {
        return balances[i];
      }
    }
  }

}

/* 
Exercise 2: Why no loop?
Below is another implementation for the same contract. 
1- Play around with the code, deply the contract and check the gasses when calling transfer function. 
2- Try increasing the number of accounts. Check the gasses. 
3- What is the difference in gass usage? 
*/

/* 
Exercise 3: Is require, required?
1- Try calling both transfer and transfer2 functions. 
2- Try calling them in a way that they fail (transfering a value more than the balance). 
3- What is the difference? 
*/

/* 
Exercise 4: self destruction!
1- Try calling close function. What does it do?
2- There is a security vulnerability in this function. Can you find it?s 
*/

contract Token {

  mapping(address => uint) balances;
  uint public totalSupply;
  address public owner;

  constructor(uint _initialSupply) {
    balances[msg.sender] = totalSupply = _initialSupply;
    owner = msg.sender;
  }

  function transfer(address _to, uint _value) public returns (bool) {
    require(balances[msg.sender] - _value >= 0);
    balances[msg.sender] -= _value;
    balances[_to] += _value;
    return true;
  }

  function transfer2(address _to, uint _value) public returns (bool) {
    if(balances[msg.sender] - _value >= 0)
    {
      balances[msg.sender] -= _value;
      balances[_to] += _value;
      return true;
    }
    else 
    {
      return false;
    }
  }

  function balanceOf(address _owner) public view returns (uint balance) {
    return balances[_owner];
  }

  function close(address payable _to) public 
  { 
    selfdestruct(_to); 
  }
}
