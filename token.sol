//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract spaceEnergy{
    // have total supply
    // tranferrable
    // name
    // symbol
    // decimal
    // user balance
    // burnable


    //*********** State Variables **********//

    uint constant totalSupply = 10000;
    uint public circulatingSupply;
    string constant name = "Space Energy" ;
    string constant symbol = "SEG";
    uint constant decimal = 18;
    address owner;

    mapping(address => uint) public _balance;

    event tokenMint(address _to, uint amount);
    event _transfer(address from, address to,uint amount);

    constructor(){
        owner == msg.sender;
    }

    function _name() public pure returns(string memory){
        return name;
    }

    function _symbol() public pure returns(string memory){
        return symbol;
    }

    function _decimal() public pure returns(uint){
        return decimal;
    }

    function mint(uint amount, address _to) public returns(uint){
        circulatingSupply += amount; // increase total circulating supply
        require(circulatingSupply <= totalSupply, "");
        require(_to != address(0), "mint to address zero");
        uint value = amount * decimal;
        _balance[_to] += value; // increase balance of to
        emit tokenMint(_to, value);
        return amount;
    }

    function transfer(address _to, uint amount) public{
        require(_to != address(0), "mint to address zero");
        uint userBalance = _balance[msg.sender];
        require(userBalance >= amount, "insufficient balance");
        uint burnableToken = _burn(amount);
        uint transferrable = amount - burnableToken;
        _balance[msg.sender] -= amount;
        _balance[_to] += transferrable;

        emit _transfer(msg.sender, _to, amount);
    }

    function _burn(uint amount) private returns(uint256 burnableToken) {
        burnableToken = calculateBurn(amount);
        circulatingSupply -= burnableToken / decimal;
    }

    function calculateBurn(uint amount) public pure returns(uint burn){
        burn = (amount * 10)/100;
    }

    function balanceOf(address who) public view returns(uint){
        return _balance[who];
    }

    //////////////////////////////////////////////

    mapping(address => mapping(address=> uint))_allowance;

    modifier checkBalance(address _owner, uint amount) {
        uint balance = balanceOf(_owner);
        require(balance >= amount, "insufficient funds");
        _;
    }

    function Approve(address spender, uint amount) external checkBalance(msg.sender, amount) {
        require(spender != address(0));
        uint allow = _allowance[msg.sender][spender] = amount;
        if(allow == 0){
            _allowance[msg.sender][spender] = amount;
        }
        else{
            _allowance[msg.sender][spender] += amount;
        }

    }

    function transferFrom(address from, address _to, uint amount) external  checkBalance(from, amount){
        require(_to == msg.sender, "not spender");
        uint allowanceBalance = _allowance[from][_to];
        require(allowanceBalance >= amount, "no allowance for you");
        _allowance[from][_to] -= amount;
        _balance[from] -= amount;

    }
}