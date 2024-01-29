# Final Thoughts and Solution

It took me 3 days or so to get past gateTwo, and even then it was a brute force solution, not a proper gas counting solution.

1. gateOne - you just reroute the transaction through a contract to get past this one.
2. gateThree - the gateKey was figured out by using `chisel` in Foundry :
   `uint64(uint160(tx.origin))` gives a hex value: take the last 16 digits, or the last 8 bytes. But then make the second-last two bytes or the four digits after the first 8 digits(4 bytes) 0, or nullify them. (There could be a better way of doing it, more technical and cool. I did this way)
3. gateTwo - This was the one tough to crack - I tried deploying on RemixVM and then debugging the transactions, but then

```solidity
require(gasleft() % 8191==0);
```

was never shown to be hitting on the debugger.

1.  `forge test -vvvv` was also not helpful, and using a custom error with a `gasleft()` `revert` would have messed up the gas too.
2.  So in the end went brute force: the gas sent to the contract begins at 81910, which is a multiple of 8191, and then loops till the next multiple of 8191. Works, but not elegant.

I'm keeping all the notes below, just to see the thought process later.

```solidity
uint16(uint160(tx.origin)) == uint32(uint64(_gateKey)) == uint16(uint64(_gateKey))

```

GateKeeper Address on Sepolia: 0x6Ec9109f3ED94d54Ee998539854be06BC70a3bfD

256 - 32 bytes
128 - 16 bytes
64 - 8 bytes
32 - 4 bytes
16 - 2 bytes
8 - 1 byte

Last 2 bytes: 0xfcdc

Last 4 bytes, maybe: 0xefa9fcdc

Full 8 bytes, hopefully: 0x005e9ba0efa9fcdc

Modified 8 bytes: 0x005e9ba00000fcdc - this looks to be the gateKey!!

Modifier one gas: 46

Tester gateKey for remixVM: 0x3fcb875f0000ddc4

After testing on Remix: gasleft() is what's failing.

GasConsumed in a prototype: 22149 ?!!

2nd and 3rd Try: 5049

4th: 2249

5th: 5049

### Values

My address : 0xcF78399B272E71F23F00b453005e9ba0EFa9FcDc
gateKey: 0x005e9ba00000fcdc

Anvil Account(0) : 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
gateKey: 0x827279cf00002266

Some random address from forge test: 0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38
gateKey: 0x83f33e0700001f38

`cast` method to send eth to a different address on a local chain, and then use that address using `vm.prank()` for testing:

cast send --value 1000000000000000000000 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 0xcF78399B272E71F23F00b453005e9ba0EFa9FcDc

### Remix Debugger

Remaining gas: 2973324

Gasused: 26676

2973324
