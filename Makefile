all    :; dapp --use solc:0.5.10 build
clean  :; dapp clean
test   :; dapp --use solc:0.5.10 test -v

deploy: all
	dapp create $$(grep -E 'contract Mosm.+ is Mosm' src/mosm.sol  | awk '{print $$2}')

estimate:
	seth estimate --create $$(cat out/dapp.sol.json | jq -r '.contracts | ."src/mosm.sol" | .Mosm.evm.bytecode.object') 'Mosm()'

dump-prices: 
	@echo "Be sure to run 'dapp testnet --accounts XX' first!"
	START_PRICE_FROM=100 SKIP_MEDIAN_SETUP=true DUMP_PRICES_ONLY=true ./test_median.sh ethusd 0x0

