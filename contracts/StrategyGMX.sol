// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.19;

interface IGMX {
    function depositETH() external payable;
    function withdrawETH(uint256) external;
}

contract StrategyGMX {
    IGMX public gmx;

    constructor(address _gmx) {
        gmx = IGMX(_gmx);
    }

    function investETH() external payable {
        gmx.depositETH{value: msg.value}();
    }
}