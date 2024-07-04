// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract BytecodeDeployer {
    address public deployedContractAddress;

    function deployFromBytecode(bytes memory bytecode) public returns (address) {
        address child;
        assembly {
            mstore(0x0, bytecode)
            child := create(0, 0xa0, calldatasize())
        }
        require(child != address(0), "Deployment failed");
        deployedContractAddress = child;
        return child;
    }
}
