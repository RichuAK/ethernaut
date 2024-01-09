// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Jedi
 * @author Richu A Kuttikattu
 * @notice Using selfdestruct to force ether into the target contract, even if it doesn't have any recieve or fallback functions.
 * @dev selfdestruct() is on its way to be fully deprecated: the OPCODE in itself is going to be taken out.
 */
contract Jedi {
    constructor() payable {}

    function useTheForce() public {
        selfdestruct(payable(0xD6C7c7b1Cba8461Cf9bb67A2E2aB08D4ffaA0ACf));
    }
}
