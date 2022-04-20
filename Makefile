all    :; dapp --use solc:0.5.10 build
clean  :; dapp clean
test   :; dapp --use solc:0.5.10 test -v
deploy :; dapp create Mosm
