# SafeMath / OverFlow

The contract is exploited using math overflow/underflow. No other contract was needed.

Since the initial balance of the owner is 20 tokens, you call the transfer function with a value that's greater than 20: 21 for instance. The uint rolls back into maximum value after hitting 0, and the require check succeeds(fails, I guess?).

OpenZeppelin's SafeMath library was the solution used by all until recently.

This issue is more or less redundant since 0.8.0 and onwards, since Solidity checks for Math Overflow by default. You can still bypass this by doing an `unchecked` block within your code. Not recommended.
