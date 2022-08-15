all    :; dapp --use solc:0.5.10 build
clean  :; dapp clean
test   :; dapp --use solc:0.5.10 test -v
deploy :; dapp create Mosm
dump-prices: 
	@echo "Need to run 'dapp testnet --accounts XX' first!"
	START_PRICE_FROM=100 SKIP_MEDIAN_SETUP=true DUMP_PRICES_ONLY=true ./test_median.sh ethusd 0x0

