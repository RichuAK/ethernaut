// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract DenyDenial {
    fallback() external payable {
        assert(false);
    }
}
