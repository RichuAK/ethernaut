// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract DenyDenial {
    fallback() external payable {
        // ensures an invalid opcode is executed, halting all the transaction. Works with any solidity version
        assembly {
            invalid()
        }
    }
}
