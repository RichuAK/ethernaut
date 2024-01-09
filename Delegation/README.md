# Method 1

Get the return value of `abi.encodeWithSignature("pwn()")` and pass it as `calldata` to the contract address.

# Method 2

In Remix, you can load the `Delegate` contract with the `Delegation` address. This lets you call `pwn` from the UI itself, but then send it to the `Delegation` address. Works fine, and you can avoid getting the bytes value using `abi.encodeWithSignature()`

## Important note

Need to set a much higher gas limit for the transaction to succeed. Did it on Metamask, doing it in Remix didn't work
