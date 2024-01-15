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
