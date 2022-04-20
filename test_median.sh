#!/usr/bin/env bash

# For use with `dapp testnet --accounts N`

# E.g.

# Terminal 1
# dapp testnet --accounts 13

# Terminal 2
# dapp create MosmETHUSD
# ./test_median.sh $PAIR $MEDIAN_ADDRESS
# ./test_median.sh ETHUSD 0xabc123

set -e

pair=ETHUSD
usage() {
    echo "Usage: $0 <PAIR> <MOSM_ADDRESS>"
    echo "E.g.   $0 ETHUSD 0xdeadbeef"
}
[[ -z "$1" ]] && {
    usage
    exit 1
}
[[ -z "$2" ]] && {
    usage
    exit 1
}
median=$2

chain=$(seth chain 2>/dev/null) || {
    echo "Not connected, please run:"
    echo "  dapp testnet --accounts n (where n is an odd number)"
    echo ""
    exit 1
}

[[ $chain = ethlive ]] && {
    echo "Wow, you are connected to mainnet. Exiting!"
    exit 1
}

[[ $(seth rpc eth_accounts | cut -b 3-4 | sort | uniq | wc -l) == $(seth rpc eth_accounts | wc -l) ]] || {
    echo "There is a slot clash in the accounts that seth generated, try rerunning dapp testnet."
    exit 1
}

function hash {
    local wat wad zzz
    
    wat=$(seth --to-bytes32 "$(seth --from-ascii "$1")")    
    wad=$(seth --to-wei "$2" eth)
    wad=$(seth --to-word "$wad")
    zzz=$(seth --to-word "$3")

    hexcat=$(echo "$wad$zzz$wat" | sed 's/0x//g')
    seth keccak 0x"$hexcat"
}

function join { local IFS=","; echo "$*"; }

if [ -z "$GET_ACCOUNTS_FROM_ETH_KEYSTORE" ]; then
    mapfile -t accounts < <(seth rpc eth_accounts)

    minaccounts=1
    [[ ${#accounts[@]} -ge "$minaccounts" ]] || {
        echo "You need at least $minaccounts accounts"
        exit 1
    }
else
    # This lets you pull accounts from a real keystore, like for deploys to testnets
    mapfile -t accounts < <(ethsign ls | grep -v $ETH_FROM | awk '{print $1}')
fi

if [ -z "$ETH_FROM" ]; then
    echo "No ETH_* env vars set. Setting them up for testchain."
    ETH_GAS=6000000
    ETH_KEYSTORE=~/.dapp/testnet/8545/keystore
    ETH_PASSWORD=./empty
    ETH_RPC_ACCOUNTS=yes
    ETH_FROM=$(seth --to-address "${accounts[0]}")
    export ETH_FROM ETH_KEYSTORE ETH_PASSWORD ETH_GAS ETH_RPC_ACCOUNTS
fi

if [ -z "$SKIP_MEDIAN_SETUP" ]; then
    (set -x; seth send "$median" 'setBar(uint256)' "$(seth --to-word ${#accounts[@]})")
    echo "Lifting ${#accounts[@]} accounts"
    acc=$(echo "${accounts[@]}" | tr ' ' ',')
    (set -x; seth send "$median" 'lift(address[] memory)' "[$acc]")
fi

echo "Median: $median"
i=1
ts=1549168920
for acc in "${accounts[@]}"; do
    price=$((250 + i))
    i=$((i + 1))
    hash=$(hash "$pair" "$price" "$ts")
    empty_passphrase_file='./empty'
    sig=$(ethsign msg --from "$acc" --data "$hash" --passphrase-file "$empty_passphrase_file")
    echo "ethsign msg --from \"$acc\" --data \"$hash\" --passphrase-file \"$empty_passphrase_file\""
    res=$(sed 's/^0x//' <<< "$sig")
    r=${res:0:64}
    s=${res:64:64}
    v=${res:128:2}
    v=$(seth --to-word "0x$v")
    
    price=$(seth --to-wei "$price" eth)
    prices+=("$(seth --to-word "$price")")
    tss+=("$(seth --to-word "$ts")")
    rs+=("0x$r")
    ss+=("0x$s")
    vs+=("$v")
    cat <<EOF
Address: $acc
  val: $price
  ts : $ts
  v  : $v
  r  : $r
  s  : $s
EOF
done

allts=$(join "${tss[@]}")
allprices=$(join  "${prices[@]}")
allr=$(join "${rs[@]}")
alls=$(join "${ss[@]}")
allv=$(join "${vs[@]}")

echo "Sending tx..."
tx=$(set -x; seth send --async "$median" 'poke(uint256[] memory,uint256[] memory,uint8[] memory,bytes32[] memory,bytes32[] memory)' \
"[$allprices]" \
"[$allts]" \
"[$allv]" \
"[$allr]" \
"[$alls]")

echo "TX: $tx"
echo SUCCESS: "$(seth receipt "$tx" status)"
echo GAS USED: "$(seth receipt "$tx" gasUsed)"

(set -x; seth send "$median" 'kiss(address)' $ETH_FROM)
(set -x; seth call "$median" 'peek()(uint,bool)')
