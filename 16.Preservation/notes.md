# DelegateCall

`Delegatecall`s are low-level calls which helps you to execute some other contract's code in your own code's context. They're both powerful and dangerous. I think of it as replacing your guts with someone else's guts for bit, but the ingestion and the nutrition goes to you. (Kinda icky, but meh)

The crucial thing to understand is how storage is handled by `delegatecall`. They don't care about variable names or types or any of that sort. Solidity can convert any type to any other under the hoods, so all `delegatecall` care about is storage slot. A function is basically a snippet of compute: manipulate data.

So if you have a function that manipulates a `storage` variable, what Solidity does is look at the storage slot of that variable, does the compute stores it in the set storage slot (if that's what the function says it to do).

So `delegatecall` basically takes these instructions at the low level.

A function might be:

1. Take data at storage slot 1
2. Multiply it with data at storage slot 2
3. Store it at storage slot 0

That's all it sees. Nothing more, nothing else. Variable names and types doesn't matter.

# The Exploit

Here's the library contract:

```solidity
contract LibraryContract {
    // stores a timestamp
    uint256 storedTime;

    function setTime(uint256 _time) public {
        storedTime = _time;
    }
}

```

The function `setTime` basically is **update storage slot 0 with whatever value I receive as the parameter**

And we exploit this.

Since `delegatecall` takes this function in its own context, the function basically updates slot 0 of the **Preservation** contract when the contract uses `delegatecall`

```solidity
function setFirstTime(uint256 _timeStamp) public {
        timeZone1Library.delegatecall(abi.encodePacked(setTimeSignature, _timeStamp));
    }
```

# The Hack

1. Deploy `HackPreservation` which has a function that updates storage slot 2 a set value (the `owner` gets updated)
2. Call `setFirstTime` on `Preservation` with a `uint` value that's basically the address of `HackPreservation` that we just deployed. It basically updates `Preservation::timeZone1Library`.
3. Now that `timeZone1Library` has been updated to our contract, we can call `Preservation::setFirstTime` again with an arbitrary `timeStamp`, since we know the function just updates `owner` to our desired value.
