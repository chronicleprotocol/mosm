#!/usr/bin/env bash

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <MOSM_ADDRESS>"
    exit 1
fi
mosm=$1

[[ -z "$ETH_FROM" ]] && {
    echo "ETH_FROM (and ETH_* vars) need to be set. Cannot continue"
    exit 1
}

step=20

seth send $mosm 'osm_kiss(address)' $ETH_FROM
seth send $mosm 'osm_poke()'
seth send $mosm 'step(uint16)' $step
echo "Current hop:"
seth call $mosm 'hop()(uint16)'
echo "Current zzz:"
seth call $mosm 'zzz()(uint256)'
echo "Current peek:"
seth call $mosm 'osm_peek()(bytes32,bool)'

echo "Taking a nap for $step seconds..."
sleep $step
echo "Poking..."
seth send $mosm 'osm_poke()'
echo "Updated peek:"
res=$(seth call $mosm 'osm_peek()(bytes32,bool)')
echo "$res"
cur=$(echo "$res" | head -n 1)
seth --to-dec "$cur"
zzz=$(seth call $mosm 'zzz()(uint256)')
echo "Current zzz: $zzz"
