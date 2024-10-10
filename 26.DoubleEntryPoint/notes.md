# The Issue

A legacy token gets 'updated' to a new token. Both these contracts have different addresses, and when a legacy transaction is triggered, the updated contract's transaction gets executed. Not too bad on the surface, until other protocols use both these contracts and assume different behaviors being controlled by contract addresses.

```solidity
function sweepToken(IERC20 token) public {
        require(token != underlying, "Can't transfer underlying token");
        token.transfer(sweptTokensRecipient, token.balanceOf(address(this)));
    }
```

`CryptoVault::sweepToken` assumes that if the `token` being passed is the `underlying` token, then the transaction will be reverted. Innocent enough.

But unbeknownst to `CryptoVault`, the `legacy` token has a transfer implementation where if a `delegate` is set, then the `delegateTransfer` function is called.

```solidity
function transfer(address to, uint256 value) public override returns (bool) {
        if (address(delegate) == address(0)) {
            return super.transfer(to, value);
        } else {
            return delegate.delegateTransfer(to, value, msg.sender);
        }
    }
```

So what is the `delegateTransfer` functionality, in the `DoubleEntryPoint` contract?

```solidity
function delegateTransfer(address to, uint256 value, address origSender)
        public
        override
        onlyDelegateFrom
        fortaNotify
        returns (bool)
    {
        _transfer(origSender, to, value);
        return true;
    }
```

It calls its own transfer, that too the internal `_transfer`, no less.

So if Legacy Contract has `DoubleEntryPoint` as its delegate, then someone calling `transfer` on Legacy is basically triggering `DoubleEntryPoint` transfer. And that's the hack.

A user can pass in `Legacy`'s address into `CryptoVault`, and the vault check's whether that's the address of the `underlying` token, which isn't, and lets the user trigger a transfer. And the user gets `DoubleEntryPoint` tokens.

# Setting up detection

We set a detection bot which raises an alert when the `origSender`, or from address is the vault Address.

I tried adding the function signature check as well, and that failed, and that looks to be redundant as well since the `fortaNotify` modifier is added only to the `delegateTransfer` function in `DoubleEntryPoint`. So whenever the `delegateTransfer` function is triggered, the modifier checks whether the transaction is for a Vault withdrawal, and if it is, the transaction is reverted.

# Learnings

I didn't exactly enjoy the process this time. It felt, odd. A bit cumbersome.

But, having done it, I can see the value in it. You add the `fortaNotify` modifier for posterity, if any vulnerabilities get detected and then you add a bot to revert.

Kinda neat, but is it worth adding the bot check for every transaction gas-wise? I don't know.
