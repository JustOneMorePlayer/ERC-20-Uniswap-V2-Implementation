//SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "./Token.sol";
import "hardhat/console.sol";

error LiquidityPool__PoolNotEmpty();
error LiquidityPool__PoolEmpty();

contract LiquidityPool{
    ERC20Token public WETH;
    ERC20Token public token;
    LiquidityPoolToken public liquidityPoolToken;
    

    uint256 constant feeProtocol = 5;
    uint256 constant feeUser = 30;


    constructor(address _addressWETH, address _addresstoken){
        WETH = ERC20Token(_addressWETH);
        token = ERC20Token(_addresstoken);

        liquidityPoolToken = new LiquidityPoolToken(
            string.concat("WETH ", token.name(), " Liquidity Pool Token"), 
            string.concat("WETH", token.symbol(), "LP")
        );     
    }

    function initializePool(uint256 _valueWETH, uint256 _valueToken) public {
        if(thisWETHBalance() != 0 || thisTokenBalance() != 0) revert LiquidityPool__PoolNotEmpty();
        
        WETH.transferFrom(msg.sender, address(this), _valueWETH);
        token.transferFrom(msg.sender, address(this), _valueToken);

        liquidityPoolToken.mint(msg.sender, _valueWETH);   
    }

    function addLiquidity(uint256 _valueWETH) public{
        if(thisTokenBalance() == 0 && thisWETHBalance() == 0) revert LiquidityPool__PoolEmpty();
        
        WETH.transferFrom(msg.sender, address(this), _valueWETH);
        token.transferFrom(msg.sender, address(this), _valueWETH * thisTokenBalance() / thisWETHBalance());

        liquidityPoolToken.mint(msg.sender, liquidityPoolToken.totalSupply() *  _valueWETH / thisWETHBalance());
    }

    function removeLiquidity(uint256 _valueLPToken) public {
        //if(thisTokenBalance() == 0 && thisWETHBalance() == 0) revert LiquidityPool__PoolEmpty();
        liquidityPoolToken.burn(msg.sender, _valueLPToken);

        WETH.transfer(msg.sender, thisWETHBalance() * _valueLPToken / (liquidityPoolToken.totalSupply() + _valueLPToken));
        token.transfer(msg.sender, thisTokenBalance() * _valueLPToken / (liquidityPoolToken.totalSupply() + _valueLPToken));
    }

    function WETHToTokenSwap(uint256 _valueWETH) public {
        WETH.transferFrom(msg.sender, address(this), _valueWETH);
        uint256 valueToken_ = thisTokenBalance() - ((thisWETHBalance() - _valueWETH) * thisTokenBalance()) / thisWETHBalance();
        token.transfer(msg.sender, valueToken_);
    }

    function tokenToWETHSwap(uint256 _valueToken) public {
        token.transferFrom(msg.sender, address(this), _valueToken);
        uint256 valueWETH_ = thisWETHBalance() - ((thisTokenBalance() - _valueToken) * thisWETHBalance()) / thisTokenBalance();
        WETH.transfer(msg.sender, valueWETH_);

    }

    function thisWETHBalance() internal view returns (uint256) {
        return WETH.getBalanceOf(address(this));
    }

    function thisTokenBalance() internal view returns (uint256) {
        return token.getBalanceOf(address(this));
    }
}

/*
     
     * Sets the product constant and the exchange rate between WETH and TA for the first time
     *
    function firstAddLiquidity() public {
        if (
            contractWETH.getBalanceOf(address(this)) != 0 ||
            contractTA.getBalanceOf(address(this)) != 0 ||
            totalSupply != 0
        ) revert LiquidityPoolToken__PoolNotEmpty();
    }
*/
