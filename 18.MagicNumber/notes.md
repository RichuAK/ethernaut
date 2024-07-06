# The Level

This one was something else. I lost sleep, and almost broke down at a point. I don't even know whether I should be proud of it, given the fact that I had a lot more resources at my disposal as compared to when this level was made public.

## The tools to learn and play

I used `remix` to deploy and interact with the blockchain (still too lazy for scripting), [evm.codes playground](https://www.evm.codes/playground) to prototype, Alejandro's amazing [Deconstructing a Solidity Contract](https://medium.com/@_ajsantander) blog series and Joshua's awesome [Demystifying Ethereum Assembly](https://www.youtube.com/watch?v=btDOvn8pLkA&t=156s) workshop as the launchpad.

# The solution

First thing in order was to get a crude understanding of what OpCodes are: the first 30 minutes or so of Joshua's workshop gives a nice introduction to the EVM stack and how to think about playing with the stack with OpCodes: how many values each opcode consumes, what to expect in the memory, how to return a value etc. Armed with this basic understanding, I started playing around at evm.codes playground, learning what it actually means to have a stack underflow or stack overflow or invalid opcode errors. The free memory pointer is an important bit that Joshua mentions(which I only realized much later, sadly).

With the knowledge of writing basic in-line Assembly, and a few AI queries, I cooked up `ByteCodeDeployer.sol`, which has a function that takes in bytes as argument and deploys a new contract with those bytes.

Thinking myself as very smart, I passed in `0x602a60005260206000f3` as the argument in `deployFromByteCode` function, expecting this bytecode will be the deployed contract's bytecode. The result? [This contract](https://sepolia.etherscan.io/address/0xda69db1489fb81261d797ef5354b1b759c06015f#code) with bytecode `0x000000000000000000000000000000000000000000000000000000000000002a`.

So much for being smart. Then it hit me: constructors, creation code and things of that sort. So the `create` opcode takes bytecode that contains not just the runtime code, but the creation code as well. Okay, how do I write creation code now? [Part II](https://medium.com/zeppelin-blog/deconstructing-a-solidity-contract-part-ii-creation-vs-runtime-6b9d60ecb44c) of Alejandro's blog series was the answer. He amazingly explains creation code, so I walked through the opcodes and identified what things `codecopy` needed: the instruction number from which to copy from, the size of the code to copy in bytes. I took the same creation code from the blog, and changed these and passed my bytecode. And then passed this whole chunk as the argument into `deployFromByteCode`. The result is [this contract](https://sepolia.etherscan.io/address/0xF9d700c4d1b6AEbCb6f12eAA7195C4b0B29D4cF4#code). The level isn't solved, but at least now I know how to have predictable runtime bytecode!

Now comes a whole bunch of [contract creations](https://sepolia.etherscan.io/address/0x2acbf0fd78ca2f4a2b60ec688a89e902022b5cd5#internaltx) in pursuit of the right runtime bytecode. This was a desert land I got lost in, where I hallucinated, got hungry, thirsty, went mad. I tried many combinations: where the number of actual opcode instructions was 10, where the total number of bytes was 10, where I pushed the function signature to the stack, where I did this and that and this and that and I kept wondering what I was missing.

It occurred to me after a sleepless night: free memory pointer. Not exactly the opcodes to store the free memory pointer (then the size becomes too large), but the fact that you store the number 42 in memory not at the 0x00 position, but at 0x80, after leaving empty space for Solidity.

So the opcode looks like this:

```
PUSH1 0x2a
PUSH1 0x80
MSTORE
PUSH1 0x20
PUSH1 0x80
RETURN
```

And the corresponding bytecode is `0x602a60805260206080f3`. 10 bytes in total.

With the full creation code, the opcode becomes

```
PUSH1 0x80
PUSH1 0x40
MSTORE
CALLVALUE
DUP1
ISZERO
PUSH2 0x000f
JUMPI
PUSH0
DUP1
REVERT
JUMPDEST
POP
PUSH1 0x0a
DUP1
PUSH2 0x001c
PUSH0
CODECOPY
PUSH0
RETURN
INVALID
PUSH1 0x2a
PUSH1 0x80
MSTORE
PUSH1 0x20
PUSH1 0x80
RETURN
```

And the corresponding bytecode: `0x608060405234801561000f575f80fd5b50600a8061001c5f395ff3fe602a60805260206080f3`

When all's said and done, the contract is [this](https://sepolia.etherscan.io/address/0x137f3f4e1a1edec0240b6d4ed4c0bd3c248c4a57#code).

It was an interesting journey. I struggled a lot, which means I learned a lot!
