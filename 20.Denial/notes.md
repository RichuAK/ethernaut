# Lesson 1: Read the comments

The first reaction was to deploy a contract that would `revert` in its fallback and make it the partner. Of course it didn't work since `.call` method's revert doesn't get bubbled up into whole transaction execution. And this was already mentioned in the level's comments:

```solidity
// The recipient can revert, the owner will still get their share
partner.call{value: amountToSend}("");
```

So, read the comments. Also the fact that `revert` in call doesn't get bubbled up. Good lesson.

# Lesson 2: It's not a Re-entrancy gig.

The next try was to try re-entrancy. The thought was to drain the contract's balance to zero, and then add back a value less than 100 so that `amountToSend` would be 0 while `address(this).balance` would be greater than zero. While the contract is susceptible to a re-entrancy, the attack doesn't entirely drain the balance: the attack fails after a few re-entrancy calls (stack too deep?). And it didn't seem right, the level being called `Denial` and all. It must be a proper denial-of-service attack.

# Lesson 3: The all-consuming assert

I came to the assumption that the goal is to find a way to halt the entire transaction from an attack contract which would be the partner, to leverage

```solidity
// The recipient can revert, the owner will still get their share
partner.call{value: amountToSend}("");
```

`revert` doesn't work, but there has to be a way. Google searches and wanderings led to `assert`, which would consume all the gas in the transaction, as opposed to `require` and `revert`. If `assert` is false, it consumes all the remaining gas, which means there won't be any gas left for the `transfer` to the owner.

So the attack contract would look like this:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DenyDenial {
    fallback() external payable {
        assert(false);
    }
}
```

The `fallback` function triggers an `assert(false)`, all gas is consumed, execution fails. Neat.

# Lesson 4: Solidity versions and compilers (and opcodes), and knowing when to be a bit humble.

The `assert(false)` really should have worked, but it didn't. While the transfer to the `partner` failed, the transfer to the `owner` succeeded. I spent a long while on this, convinced this solution should have worked, and googled.

Turns out it's a quirk of the solidity version, and the differences in how the code gets compiled into opcodes.

[This post](https://ethereum.stackexchange.com/questions/107882/ethernaut-level-20-denial-probably-no-longer-solvable-why) shows that the code works for Solidity `0.8.0`, but not `0.8.5` and higher. It didn't work for `0.8.0` for me, and I had to change it to `0.6.0` to make it work.

## Opcodes and in-line assembly

The issue seems to be that in recent versions of solidity, the `assert(false)` compiles down to a `REVERT` opcode, rather than an `INVALID` opcode for some reason. We want an `INVALID` opcode to consume all the gas. The solution? In-line assembly that would ensure an `INVALID` opcode:

```solidity
fallback() external payable{
        assembly {
            invalid()
        }
    }
```

Doesn't matter with the solidity version, of course.

# Lesson 5: Other solutions, and a larger perspective to look at DoS.

The goal is to eat up gas in any way. As mentioned in one of the solutions in [the post](https://ethereum.stackexchange.com/questions/107882/ethernaut-level-20-denial-probably-no-longer-solvable-why), you can also set up an infinite loop in the `fallback` to eat up all the gas.

```solidity
fallback() external payable{
        int a =0;
        while(true){
            a = a +1;
        }
    }
```

This works with the latest solidity version as well.

So, lots of lessons learned, and fairly humbled that I did have to go to stackexchange in the end.
