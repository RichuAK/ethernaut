// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

interface IForta {
    function setDetectionBot(address detectionBotAddress) external;
    function notify(address user, bytes calldata msgData) external;
    function raiseAlert(address user) external;
}

interface IDetectionBot {
    function handleTransaction(address user, bytes calldata msgData) external;
}

contract DetectionBot is IDetectionBot {
    address public vaultAddress = 0xA861AfC989b75A4728F11c5fe6366afC39Cf469F;

    function handleTransaction(address user, bytes calldata msgData) external {
        (,, address origSender) = abi.decode(msgData[4:], (address, uint256, address));
        // bytes memory funcSig = msgData[:4];
        // bytes memory delegateFuncSig = '0x9cd1a121';
        if (origSender == vaultAddress /* && keccak256(funcSig) == keccak256(delegateFuncSig)*/ ) {
            IForta(msg.sender).raiseAlert(user);
        }
    }
}
