// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import {Test} from "forge-std/Test.sol";
import {GatekeeperOne} from "../src/Gatekeeperone.sol";
import {EnterGateKeeperOne} from "../src/EnterGatekeeperone.sol";
import {DeployGateKeeperOne} from "../script/DeployGateKeeperOne.s.sol";
import {DeployEnterGateKeeperOne} from "../script/DeployEnterGateKeeperOne.s.sol";

contract TestGateKeeperOne is Test {
    GatekeeperOne gateKeeperOne;
    EnterGateKeeperOne enterGateKeeperOne;

    function setUp() external {
        DeployGateKeeperOne deployGateKeeperOne = new DeployGateKeeperOne();
        gateKeeperOne = deployGateKeeperOne.run();
        DeployEnterGateKeeperOne deployEnterGateKeeperOne = new DeployEnterGateKeeperOne(address(gateKeeperOne));
        enterGateKeeperOne = deployEnterGateKeeperOne.run();
    }
}
