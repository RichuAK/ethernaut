// SPDX-License-Identifier: MIT

pragma solidity <0.7.0;

contract DestructMe {
    function destructMe() public {
        selfdestruct(payable(0xcF78399B272E71F23F00b453005e9ba0EFa9FcDc));
    }
}
