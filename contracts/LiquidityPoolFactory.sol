//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./Token.sol";
import "./LiquidityPool.sol";

error LiquidityPoolFactory__LiquidityPoolAlreadyExists();



contract LiquidityPoolFactory{
    event mintedNewPool(address indexed newLiquidityPoolAddress);

    ERC20Token public immutable WETH;
    address public admin;
    LiquidityPool[] liquidityPools;

    mapping(string => bool) poolListing;

    constructor(address _addressWETH){
        WETH = ERC20Token(_addressWETH);
        admin = msg.sender;
    }

    function mintNewPool(address _addresstoken) public returns(bool){
       if(poolListing[ERC20Token(_addresstoken).symbol()]) revert LiquidityPoolFactory__LiquidityPoolAlreadyExists();
       LiquidityPool newLiquidityPool= new LiquidityPool(address(WETH), _addresstoken);
       liquidityPools.push(newLiquidityPool);

        emit mintedNewPool(address(newLiquidityPool));

       poolListing[ERC20Token(_addresstoken).symbol()] = true;

       return true;
    }


}

