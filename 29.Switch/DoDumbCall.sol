// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract DoDumbCall {
    function callContract(address _contract, bytes memory _data) public {
        (bool success,) = _contract.call(_data);
        if (!success) {
            revert();
        }
    }
}
