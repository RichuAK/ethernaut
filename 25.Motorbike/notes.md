## (Lack of) Selfdestruct

The goal of the level is to `selfdestruct` the `Engine` of Motorbike and to make Motorbike unusable.

I found out the address of `engine`, which was stored at slot `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc` in the Motorbike contract using `cast storage`

Once the address was found, it was easy to see that the `Engine` contract was not initialized: this means I could easily become `upgrader` by calling `Engine::initialize`.

Now that I'm the `upgrader`, I can call `Engine::upgradeToAndCall` with `DestructMe`'s address and `destructMe` as the data. This should `selfdestruct` the `Engine` contract.

But, having called it, I'm still not passing the level.

I tried `upgradeToAndCall` transaction again and that too went through. And etherscan shows [two selfdestructs](https://sepolia.etherscan.io/address/0xddbEaC2180BBa8975E35711207D03647107e39B9#internaltx) on the contract, which should never happen by definition.

So after a further digging, I found out that `selfdestruct` behavior has been changed since the Decun Upgrade of the network, so this solution would never work.

The [issue has been discussed](https://github.com/OpenZeppelin/ethernaut/issues/701) on Ethernaut GitHub.

As discussed there, an EOA with no code cannot really solve the level, only a contract that initializes the level and submit the level in the same transaction can do so, to really empty the code in `Engine`.

Again as discussed, [EIP-7702](https://eips.ethereum.org/EIPS/eip-7702) could be a solution to get an EOA to solve the level, but it's not a transaction type yet.
