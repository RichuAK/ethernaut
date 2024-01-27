# Struggles

The greatest struggle was understanding how to pass both these two `requires` at the same time:

```solidity
require(msg.sender != tx.origin);
uint256 x;
assembly {
    x := extcodesize(caller())
    }
require(x == 0);
```

The first one clearly is about routing the transaction through a contract, but then the second one forces your contract's code size to be zero. How on earth can you do both?!

Turns out there's a way, as there usually is.

At the time of contract deployment, when `constructor` is being executed, the code size of the contract is zero. It's only after the `constructor` is executed that the contract node is set. New Info!
