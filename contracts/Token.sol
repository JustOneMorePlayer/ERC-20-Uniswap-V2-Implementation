//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

error ERC20Token__DontHaveEnoughToSpend();
error ERC20Token__DontHaveEnoughAllowed();
error Token__NotOwner();
error LiquidityPoolToken__PoolNotEmpty();

abstract contract ERC20Token {
    string public name;
    string public symbol;
    uint256 public totalSupply;

    mapping(address => uint256) public balance;
    mapping(address => mapping(address => uint256)) public allowance;

    modifier enoughAmountAllowed(address _from, uint256 _value) {
        if (allowance[_from][msg.sender] < _value) revert ERC20Token__DontHaveEnoughAllowed();
        _;
    }

    modifier enoughAmountHolded(address _spender, uint256 _value) {
        if (balance[_spender] < _value) revert ERC20Token__DontHaveEnoughToSpend();
        _;
    }

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
    }

    function approve(address _spender, uint256 _value) public {
        allowance[msg.sender][_spender] = _value;
    }

    function disapprove(address _spender, uint256 _valueToSubstract) public {
        if (allowance[msg.sender][_spender] <= _valueToSubstract)
            allowance[msg.sender][_spender] = 0;
        else allowance[msg.sender][_spender] -= _valueToSubstract;
    }

    function transfer(address _to, uint256 _value) public enoughAmountHolded(msg.sender, _value) {
        balance[msg.sender] -= _value;
        balance[_to] += _value;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public enoughAmountAllowed(_from, _value) enoughAmountHolded(_from, _value) {
        balance[_from] -= _value;
        balance[_to] += _value;
    }

    function getBalanceOf(address _address) public view returns (uint256) {
        return balance[_address];
    }

    function getAllowanceOf(address _owner, address _spender) public view returns (uint256) {
        return allowance[_owner][_spender];
    }

    function decimals() public pure returns (uint256) {
        return 18;
    }
}

contract WrappedToken is ERC20Token {
    constructor(string memory _name, string memory _symbol) ERC20Token(_name, _symbol) {
        totalSupply = 0;
    }

    function wrapEther() public payable {
        balance[msg.sender] += msg.value;
        totalSupply += msg.value;
    }

    function unwrapEther(uint256 _value) public payable enoughAmountHolded(msg.sender, _value) {
        (bool success, ) = payable(msg.sender).call{value: _value}("");
        require(success, "Call failed!");
        balance[msg.sender] -= _value;
        totalSupply -= _value;
    }
}

contract Token is ERC20Token {
    address public owner;

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _totalSupply
    ) ERC20Token(_name, _symbol) {
        owner = msg.sender;
        totalSupply = _totalSupply;
        balance[msg.sender] = _totalSupply;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) revert Token__NotOwner();
        _;
    }

    function mint(uint256 _value) public onlyOwner {
        totalSupply += _value;
        balance[msg.sender] += _value;
    }
}

contract LiquidityPoolToken is ERC20Token {
    ERC20Token contractWETH;
    ERC20Token contractTA;

    constructor(
        string memory _name,
        string memory _symbol,
        address _addressWETH,
        address _addressTA
    ) ERC20Token(_name, _symbol) {
        contractWETH = ERC20Token(_addressWETH);
        contractTA = ERC20Token(_addressTA);
        totalSupply = 0;
    }

    //modifier

    /**
     * Sets the product constant and the exchange rate between WETH and TA for the first time
     */
    function firstAddLiquidity() public {
        if (
            contractWETH.getBalanceOf(address(this)) != 0 ||
            contractTA.getBalanceOf(address(this)) != 0 ||
            totalSupply != 0
        ) revert LiquidityPoolToken__PoolNotEmpty();
    }
}
