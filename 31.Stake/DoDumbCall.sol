// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract DoDumbCall {
    function doDumbCall(address _contract, bytes memory _data) public {
        (bool success,) = _contract.call(_data);
        if (!success) {
            revert();
        }
    }

    function doDumbCallWithMoney(address _contract, bytes memory _data) public payable {
        (bool success,) = _contract.call{value: msg.value}(_data);
        if (!success) {
            revert();
        }
    }
}
