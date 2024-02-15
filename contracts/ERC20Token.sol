// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract CreateERC20Token {
    mapping(address => uint256) balance;
    mapping(address => mapping(address => uint256)) allowanceMap;
    string tokenName;
    string tokenSymbol;
    uint8 tokenDecimals;
    uint256 tokenTotalSupply;

    constructor(
        string memory _tokenName,
        string memory _tokenSymbol,
        uint8 _tokenDecimals,
        uint256 _tokenTotalSupply
    ) {
        tokenName = _tokenName;
        tokenSymbol = _tokenSymbol;
        tokenDecimals = _tokenDecimals;
        tokenTotalSupply = _tokenTotalSupply;
        balance[msg.sender] = _tokenTotalSupply;
    }

    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    function name() public view returns (string memory) {
        return tokenName;
    }

    function symbol() public view returns (string memory) {
        return tokenSymbol;
    }

    function decimals() public view returns (uint8) {
        return tokenDecimals;
    }

    function totalSupply() public view returns (uint256) {
        return tokenTotalSupply;
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return balance[_owner];
    }

    function burnToken(uint256 _value) private {
        balance[address(0)] = balance[address(0)] + _value;
        tokenTotalSupply = tokenTotalSupply - _value;
    }

    function transfer(
        address _to,
        uint256 _value
    ) public returns (bool success) {
        require(
            msg.sender != address(0),
            "Address zero cannot make a transfer"
        );
        uint256 chargeForTransfer = _value / 10;
        require(
            balance[msg.sender] > _value + chargeForTransfer,
            "You don't have enough balance"
        );
        balance[msg.sender] = balance[msg.sender] - _value - chargeForTransfer;
        burnToken(chargeForTransfer);
        balance[_to] = balance[_to] + _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool) {
        require(_from != address(0), "Address zero cannot make a transfer");
        require(_from != _to, "You can't transfer to yourself");
        uint256 chargeForTransfer = _value / 10;
        require(
            allowanceMap[_from][_to] >= _value + chargeForTransfer,
            "You allocation is not enough, Message the owner for more allocations"
        );
        balance[_from] = balance[_from] - _value - chargeForTransfer;
        allowanceMap[_from][_to] = allowanceMap[_from][_to] - _value;
        burnToken(chargeForTransfer);
        balance[_to] = balance[_to] + _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool) {
        uint256 chargeForTransfer = _value / 10;
        require(balance[msg.sender] >= _value + chargeForTransfer, "You don't have enough token to allocate");
        allowanceMap[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(
        address _owner,
        address _spender
    ) public view returns (uint256) {
        return allowanceMap[_owner][_spender];
    }
}
