// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import {Script} from "forge-std/Script.sol";
import {GatekeeperOne} from "../src/Gatekeeperone.sol";

contract DeployGateKeeperOne is Script {
    GatekeeperOne gatekeeper;

    function run() external returns (GatekeeperOne) {
        vm.broadcast();
        gatekeeper = new GatekeeperOne();
        return gatekeeper;
    }
}
