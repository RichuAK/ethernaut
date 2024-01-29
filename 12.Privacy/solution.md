## Storage slots

Solidity stores variables together in the same slot if they are small enough: to save space.

This becomes important in calculating storage slots in order to figure out private variables.

- We know that each slot is 32 bytes.
- Since the second variable is `uint256`, no packing is possible with the first `bool`, so `bool` gets the whole 32 bytes, so does the `uint256`
- The next three variables are smaller, and all of them together takes just one slot.
- Then comes the bytes array, each of 32 bytes.
- So the variable we're looking for, the last element of the bytes array is in the 6th slot, or at slot 5 if we're counting from 0 (and `cast storage` does count from 0).

## Casting bytes32 to bytes16

The process just truncates the `bytes` element: just takes the first 16 bytes and discards the rest. So the first 16 bytes of the last element of the `data` array is the answer used to unlock the contract.
