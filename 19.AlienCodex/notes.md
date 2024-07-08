# The power of Foundry

This level was supposed to be one of the toughest, but for some reason it wasn't that hard. My guess is the awesome power of `cast`.

The `modifier` in the contract didn't seem to be doing much, except to confuse storage slots. The `Ownable` contract doesn't have any other storage variable other than `owner`, which would take up slot 0. But due to storage packing the `contact` bool variable would be packed with the `owner` variable in slot 0, and the size of the dynamic array would be stored in slot 1. The array elements themselves would be stored at slot `keccak256(1)` onwards.

This much I knew. The trick was to find a way to modify storage slot 0, where the `owner` is stored. I did some `cast` calls, `cast` sends to modify state with `record`, `retract` and `revise`.

I kinda guessed that it'd be the `revise` that would finally change the variable value, but how to get access to slot 0?

I kept reading the values at a few different slots using `cast storage`.

A big part clicked when I `retracted` when the array size was already 0. The value at slot 1 showed `0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff` : underflow!

So that's one part. It took me another 10 minutes to click that that's the total number of slots a solidity contract has: `2^256` slots. So the array can potentially give you access to all of the storage slots.

Now, how to find the index number of storage slot 0?

Simple math: `keccak256(1)` = `80084422859880547211683076133703299733277748156566366325829078699459944778998`, so that's where the array starts. Assuming overflow/looping over, slot 0 would be the difference between `2^256` and this number. Which happens to be case.

So you call `revise` with `35707666377435648211887908874984608119992236509074197713628505308453184860938` and your address as the argument. Not too bad.
