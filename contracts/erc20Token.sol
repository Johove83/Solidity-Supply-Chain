// Implements Ethereum Improvement Proposal (EIP) 20 token standard
// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md

pragma solidity ^0.5.0;

import './erc20Interface.sol';

contract Aphelion is ERC20Interface {
    uint constant private MAX_UINT256 = 2**256 -1;
    mapping (address => uint256) public balances;
    mapping (address => mapping (address => uint256)) public allowed;

    uint256 public totalSupply; // Total number of tokens available
    string public name;         // Aphelion
    uint8 public decimals;      // Decimals displayed
    string public symbol;       // APHL


    constructor(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) public {
        balances[msg.sender] = _initialAmount; // Creator owns all initial tokens
        totalSupply = _initialAmount;          // Update total supply
        name = _tokenName;                     // Aphelion
        decimals = _decimalUnits;              // # of decimals
        symbol = _tokenSymbol;                 // APHL
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(_value >= 0, "Insufficient token.");
        require(balances[msg.sender] >= _value, "Insufficient funds.");
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        uint256 allowance = allowed[_from][msg.sender];
        require(balances[_from] >= _value && allowance >= _value, "Insufficient funds.");
        balances[_from] -= _value;
        balances[_to] += _value;
        if (allowance < MAX_UINT256) {
            allowed[_from][msg.sender] -= _value;
        }

        return true;

    }   

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];

    }

    function approve(address _spender, uint _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

    function totalSupply() public view returns (uint totSupp) {
        return totalSupply;
    }
}