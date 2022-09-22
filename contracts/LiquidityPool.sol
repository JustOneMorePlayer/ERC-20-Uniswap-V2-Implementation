//SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "./Token.sol";
import "hardhat/console.sol";

error LiquidityPool__PoolNotEmpty();

contract LiquidityPool{
    ERC20Token public WETH;
    ERC20Token public token;
    LiquidityPoolToken public liquidityPoolToken;
    

    uint256 constant feeProtocol = 5;
    uint256 constant feeUser = 30;


    constructor(address _addressWETH, address _addresstoken, uint256 _valueWETH, uint256 _valueToken){
        WETH = ERC20Token(_addressWETH);
        token = ERC20Token(_addresstoken);

        liquidityPoolToken = new LiquidityPoolToken(
            string.concat("WETH ", token.name(), " Liquidity Pool Token"), 
            string.concat("WETH", token.symbol(), "LP")
        );



        ////ELIMINAR
        _valueToken = 0;
        _valueWETH = 0;
        /////        


    }

    function firstAddLiquidity(uint256 _valueWETH, uint256 _valueToken) public {
        if(thisTokenBalance() == 0 && thisWETHBalance() == 0) revert LiquidityPool__PoolNotEmpty();
        
        WETH.transferFrom(msg.sender, address(this), _valueWETH);
        token.transferFrom(msg.sender, address(this), _valueToken);

        liquidityPoolToken.mint(msg.sender, _valueWETH);   
    }

    function addLiquidity(uint256 _valueWETH) public{
        
    }

    function removeLiquidity() public {}

    function swap(bool from, uint256 value) public {}

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
