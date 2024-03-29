# Mosm

Combined Median and OSM smart contract. This is an optimization of the existing [OSM](https://github.com/makerdao/osm) and [Median](https://github.com/makerdao/median) contracts that aims to reduce costs and improve flexibility.

It must be noted that this contract effectively provides independent behavior between the OSM and Median logic. That is, each "internal contract" may be managed and used in isolation. For example, authorized users (`ward`) and readers (`bud`) are defined independently so that auth for Median need not be the same set as auth for OSM.

### Optimizations

1. Eliminates cross-contract calls. Combining Median and OSM means that we remove the expense of calling external contracts. This has been demonstrated to reduce gas costs by roughly 5.64% (see "Gas efficiency" section below).
2. No-op poking. If a price has not changed after the poking interval expires, no internal state needs to be changed. This contract can be queried to check for this condition -- `noop()` -- and `poke()` will even revert on this condition.
3. Sliding window for poking. There is no ["top-of-the-hour" constraint](https://docs.makerdao.com/smart-contract-modules/oracle-module/oracle-security-module-osm-detailed-documentation#5.-failure-modes-bounds-on-operating-conditions-and-external-risk-factors) in the contract. An interval (`hop`) is defined, and you can only poke once per interval. You can still perform top-of-the-hour behavior, but you are not limited by it.
4. Reduced calldata where possible as a further cost savings.

Note that all other behaviors that exist in the original implementations of Median and OSM should retain their current behavior.

### Name collisions

The two contracts we've merged here shared some naming conventions. E.g. they both have a method named `peek()`. Since OSM is the "public facing" contract, where collisions occurred we prefixed the Median-side functions. E.g. this contract retains the `peek()` method for OSM and `median_peek()` for Median.

### Auditability

For `lift()` and `rely()` we've added append-only arrays that can be used to audit the permissions on the contract. Simply put, whenever a feed is added via `lift()`, or any time an address is given auth via `rely()` their address is appended to the respective array. These arrays are public and can easily be iterated over to obtain addresses to then check against the appropriate permissions structure.

## Build and test

To build the contract from source do

```
make all
```

In a separate terminal window, you'll want to get a testchain running.

```
dapp testnet --accounts 13
```

will start a local testnet with 13 accounts that will be used for feeds. Export all your `ETH_*` vars, e.g. `ETH_FROM`, `ETH_KEYSTORE`, etc into your environment.

Then, do

```
dapp create Mosm
```

to deploy. Now you're ready to test. Do

```
./test_median.sh ethusd <MOSM_ADDRESS_from_dapp_create_above>
```

The above will exercise the **Median** side of the contract, and set a current Median price. Now you are ready to test the **OSM** side of things. Do

```
./test_osm.sh <MOSM_ADDRESS_from_dapp_create_above>
```

And the end result is that when you call `poke()` followed by `peek()` the OSM reflects the same value that was generated by `test_median.sh`.

### Deploying to testnets

By default `test_median.sh` will look for local testchain accounts to act as feeds. This obviously won't work if you deploy to a testnet like Rinkeby. You can override the behavior to pull accounts from an alternate keystore like so:

```
GET_ACCOUNTS_FROM_ETH_KEYSTORE=y ./test_median.sh ETHUSD 0x09672B2a62Db1cd4cCE379bdde5BF41931177A72
```

## Notes

### Gas efficiency

Compared the merged contract against a traditional OSM contract (deployed on Rinkeby)

[0xa65458c2d757d790f5a79968e2790f9f47ff4165](https://rinkeby.etherscan.io/address/0xa65458c2d757d790f5a79968e2790f9f47ff4165#code)

and found that the merged contract is `5.64%` cheaper gas-wise than the existing non-merged contract configuration:

```
Merged/gasUsed:        45971
Non-merged/gasUsed:    48719
```