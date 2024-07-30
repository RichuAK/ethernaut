# Modified Dex2

The difference between this contract and the previous Dex level is that this one lacks an additional check: the `from` and `to` tokens for swapping can be anything at all. So this would be the attack vector.

# Solution

I emptied one of the tokens by the previous `Dex` attack vector, by swapping tokens back and forth. When `token1` was emptied, the `Dex` contract had a `token2` balance of 90.

In order to empty this, another `ERC20` contract was created, which had balances for both me and the `Dex` contract: 90 each. Why 90? Because the aim is to get `swapAmount` to be 90, and I was too lazy to calculate. (Actually, it was 91 when I did the actual hack because I messed up my first try and the `Dex` contract balance went up by 1, instead of being drained. )

Now you call the `swap` method with `from` as the attacker ERC20 contract, `to` as `token2` which is to be drained, and amount as 90. Another small caveat is that you need to `approve` the `Dex` contract for the amount on the attacker contract for the transfer to go through. And then you call `swap`. Done.
