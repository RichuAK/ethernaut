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
