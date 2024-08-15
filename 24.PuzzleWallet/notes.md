# Storage collision

The first step in this hack is to recognize there's a storage collision:
Both `Proxy` and `PuzzleWallet` have storage variables, and they're not handled well.

`PuzzleProxy::pendingAdmin` and `PuzzleWallet::owner` both occupy storage slot 0. This means that if there's a way to manipulate one, that manipulates the other too in the proxy pattern. Turns out `PuzzleProxy::proposeNewAdmin` does just that:

```solidity
function proposeNewAdmin(address _newAdmin) external {
    pendingAdmin = _newAdmin;
}
```

So now you can be the `owner` of `PuzzleWallet`. So far so good.

But the overarching aim is to become the `admin` of `PuzzleProxy`, which can be manipulated by manipulating `maxBalance` in `PuzzleWallet`.

`PuzzleWallet::setMaxBalance` has a catch though: the balance of the contract needs to zero. So we need to drain the contract balance.

A small caveat is that `setMaxBalance` can only be called by someone who's `whiteListed`, but that's no big deal: we can whitelist anyone since we're the `owner` now.

```solidity
function setMaxBalance(uint256 _maxBalance) external onlyWhitelisted {
    require(address(this).balance == 0, "Contract balance is not 0");
    maxBalance = _maxBalance;
}
```

# Draining PuzzleWallet

This took a while to figure out.

Reentrancy doesn't work in `PuzzleWallet:execute` since it follows CEI.

`PuzzleWallet::deposit` looks airtight.

`PuzzleWallet::multicall` seems to well-written, with `deposit.selector` checks to avoid multiple `deposit` calls and everything.

But.

```solidity
address(this).delegatecall(data[i]);
```

A `delegatecall` on itself? That's kinda new. You only ever delegate to some other contract. What is this?

The contract takes its own logic and passes it onto itself, in its own context. Inception? Matrix?

The crucial element to realize is that when you say logic, it means all logic, including the logic of the function which does the `delegatecall` as well. So you could delegate to `PuzzleWallet::multicall` from within `PuzzleWallet:multicall`. And `msg.value` and `msg.sender` persist in `delegatecalls`. Bingo.

So you have two calldata for `multicall` : one is for `deposit`, and the other is for `multicall` again, with a `deposit` snuggled up inside that calldata element. One goes in as a regular deposit, the other's `selector` is of multicall's so it passes through the selector gate and does a second `multicall` with just one element, which is `deposit`.

We do go deep, Cobb.

What does all this do: it meddles with `balances[msg.sender]`. Both the deposits go through, but the contract's balance only ever get updated once proper.

This means if you were to execute `execute`, you could drain the contract. Voila.

So you do that.

# Storage collision, again.

Now it's just a matter of calling `PuzzleWallet::setMaxBalance`. But what should be the value?

`cast to-dec 0xcF78399B272E71F23F00b453005e9ba0EFa9FcDc` gives the uint value. And you're done.
