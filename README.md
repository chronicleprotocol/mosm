# Mosm

Combined Median and OSM smart contract. Effectively, this combines the [median](https://github.com/chronicleprotocol/medianite) and [osm](https://github.com/makerdao/osm) contracts into a single contract so that we can realize a cost savings by changing the [contract-to-contract](https://github.com/makerdao/osm/blob/e36c874b4e14fba860e48c0cf99cd600c0c59efa/src/osm.sol#L133) call in `poke()`

```
function poke() {
        (bytes32 wut, bool ok) = DSValue(src).peek();
        ...
}
```

to an [internal](https://github.com/chronicleprotocol/mosm/blob/520226e71bbdf3c74c19688ac1006875c3bca35e/src/mosm.sol#L251) call:

```
function osm_poke() {
        (uint256 wut, bool ok) = this.peek();
        ...
}
```

(Otherwise, these contracts should work exactly the same as their "split out" counterparts.)

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
dapp create MosmETHUSD
```

to deploy the included ETHUSD contract. Now you're ready to test. Do

```
./test_median.sh ETHUSD <MOSM_ADDRESS_from_dapp_create_above>
```

The above will exercise the **Median** side of the contract, and set a current Median price. Now you are ready to test the **OSM** side of things. Do

```
./test_osm.sh <MOSM_ADDRESS_from_dapp_create_above>
```

And the end result is that when you call `osm_poke()` followed by `osm_peek()` the OSM reflects the same value that was generated by `test_median.sh`.

## Deploys

Rinkeby [0x09672B2a62Db1cd4cCE379bdde5BF41931177A72](https://rinkeby.etherscan.io/address/0x09672B2a62Db1cd4cCE379bdde5BF41931177A72)

## Notes

### Deploying to testnets

By default `test_median.sh` will look for local testchain accounts to act as feeds. This obviously won't work if you deploy to a testnet like Rinkeby. You can override the behavior to pull accounts from an alternate keystore like so:

```
GET_ACCOUNTS_FROM_ETH_KEYSTORE=y ./test_median.sh ETHUSD 0x09672B2a62Db1cd4cCE379bdde5BF41931177A72
```
