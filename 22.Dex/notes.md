# Patrick Collins, Precision, and Magic Numbers!

A level by Patrick Collins, yaay!

So it took a bit for me to figure this one out, and that was disappointing.

I kinda got the hunch that it would be about precision when the balances were just 10 and 100: too small for Solidity calculations.

But the actual figuring out of what to do took a while, mainly because I was confused by two of the hints: `There's more than one way to interact with a contract` and `What does 'At Address' do?`

I still don't know why these hints were relevant. Sorry Patrick, I let you down! :')

# Solution

So the trouble is the `swapPrice()` calculation, since it's dividing two very low numbers and Solidity doesn't do floating point. Imprecision abound.

You do one swap from token 1 to token 2. Cool. But then that changes the balance of the dex contract, and messes up the `swapPrice()` calculation.

You do a few of the swaps back and forth, every time swapping the whole balance of your account. The imprecision keeps accumulating, and at some point the `swapAmount` becomes higher than `Dex` balance in itself. Then you look for the exact amount to swap to completely drain `Dex` by calculating/viewing `swapPrice` yourself with different values, and it's done.
