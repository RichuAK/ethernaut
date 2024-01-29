// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import {Script} from "forge-std/Script.sol";
import {EnterGateKeeperOne} from "../src/EnterGatekeeperone.sol";

contract DeployEnterGateKeeperOne is Script {
    address gateKeeperOneAddress;

    EnterGateKeeperOne enterGatekeeper;

    constructor(address _gateKeeperOneAddress) {
        gateKeeperOneAddress = _gateKeeperOneAddress;
    }

    function run() external returns (EnterGateKeeperOne) {
        vm.broadcast();
        enterGatekeeper = new EnterGateKeeperOne(gateKeeperOneAddress);
        return enterGatekeeper;
    }
}
