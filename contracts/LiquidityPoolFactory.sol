//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./Token.sol";
import "./LiquidityPool.sol";

error LiquidityPoolFactory__LiquidityPoolAlreadyExists();

contract LiquidityPoolFactory{
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
       liquidityPools.push(new LiquidityPool(address(WETH), _addresstoken));
       poolListing[ERC20Token(_addresstoken).symbol()] = true;

       return true;
    }


}

