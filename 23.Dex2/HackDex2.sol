// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract HackDex2 is ERC20 {
    constructor() ERC20("HackDex2", "HD2") {
        super._mint(0x826D15F88448033c07c38C80fe13E59a48dBb322, 90);
        super._mint(msg.sender, 90);
    }
}
