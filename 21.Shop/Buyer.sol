// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Shop {
    function isSold() public view returns (bool) {}
    function buy() public {}
}

contract Buyer {
    Shop shop;

    constructor(address _shopAddress) {
        shop = Shop(_shopAddress);
    }

    function price() external view returns (uint256) {
        if (!shop.isSold()) {
            return 100;
        } else {
            return 10;
        }
    }

    function buyItem() external {
        shop.buy();
    }
}
