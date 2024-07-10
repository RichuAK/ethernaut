// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract DenyDenial {
    // consumes all the gas as an infinite loop, works with the latest solidity version
    fallback() external payable {
        int256 a = 0;
        while (true) {
            a = a + 1;
        }
    }
}
