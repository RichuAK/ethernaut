// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {GatekeeperOne} from "../src/Gatekeeperone.sol";
import {EnterGateKeeperOne} from "../src/EnterGatekeeperone.sol";
import {DeployGateKeeperOne} from "../script/DeployGateKeeperOne.s.sol";
import {DeployEnterGateKeeperOne} from "../script/DeployEnterGateKeeperOne.s.sol";

contract TestGateKeeperOne is Test {
    GatekeeperOne gateKeeperOne;
    EnterGateKeeperOne enterGateKeeperOne;
    // bytes8 gateKey = bytes8(0x827279cf00002266);
    uint256 gas = 999999;

    function setUp() external {
        DeployGateKeeperOne deployGateKeeperOne = new DeployGateKeeperOne();
        gateKeeperOne = deployGateKeeperOne.run();
        DeployEnterGateKeeperOne deployEnterGateKeeperOne = new DeployEnterGateKeeperOne(address(gateKeeperOne));
        enterGateKeeperOne = deployEnterGateKeeperOne.run();
    }

    function testGatePassesWithoutGateTwo() public {
        vm.prank(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
        console.log("Sender address: ", tx.origin);
        console.log("Msg Sender: ", msg.sender);
        console.log("Address Balance:", address(tx.origin).balance);
        enterGateKeeperOne.youShallPass(gas, 0x83f33e0700001f38);
        assert(gateKeeperOne.entrant() == 0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38);
    }

    function testAllGatesPassed(uint256 gassy) public {
        vm.assume(gassy > 819000);
        vm.prank(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
        // console.log("Sender address: ", tx.origin);
        // console.log("Msg Sender: ", msg.sender);
        // console.log("Address Balance:", address(tx.origin).balance);
        enterGateKeeperOne.youShallPass(gassy, 0x83f33e0700001f38);
        assert(gateKeeperOne.entrant() == 0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38);
    }

    function testPassesGateTwo() public {
        vm.prank(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
        console.log("Sender address: ", tx.origin);
        console.log("Msg Sender: ", msg.sender);
        console.log("Address Balance:", address(tx.origin).balance);
        enterGateKeeperOne.youShallPass(gas, 0x83f33e0700001f38);
        assert(gateKeeperOne.entrant() == 0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38);
    }
}
