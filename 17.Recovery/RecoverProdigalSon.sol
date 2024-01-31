// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RecoverProdigalSon {
    address payable public recovery;

    function recover(address payable _recovery) public {
        recovery = _recovery;
        recovery.call(abi.encodeWithSignature("destroy(address)", 0xcF78399B272E71F23F00b453005e9ba0EFa9FcDc));
    }
}
