# ERC20

This one is solved through an understanding of the ERC20 standard.

This `modifier` is supposed to hold the `timelock` in place:

```solidity
modifier lockTokens() {
        if (msg.sender == player) {
            require(block.timestamp > timeLock);
            _;
        } else {
            _;
        }
    }
```

But the crucial thing to realize is that this only checks whether the `transfer` function is called by the owner of the tokens, or the player.

But there are other ways to spend your money: the ERC20 standard lets you to approve a third party to spend a set amount of tokens on your behalf. So you `approve` some other address on your full balance to begin with, and then that address spends all your money, bringing the `balance` to zero.
