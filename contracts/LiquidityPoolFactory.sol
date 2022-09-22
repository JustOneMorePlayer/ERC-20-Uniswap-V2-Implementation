//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./Token.sol";
import "./LiquidityPool.sol";

contract LiquidityPoolFactory{
    ERC20Token public immutable WETH;
    address public admin;
    LiquidityPool[] liquidityPools;

    constructor(address _addressWETH){
        WETH = ERC20Token(_addressWETH);
        admin = msg.sender;
    }

    function mintNewPool(address _addressWETH, address _addresstoken, uint256 _valueWETH, uint256 _valueToken) public returns(bool){
       //require el token no esta listado ya en alguna pool
       liquidityPools.push(new LiquidityPool(_addressWETH, _addresstoken, _valueWETH, _valueToken));

       return true;
    }


}

