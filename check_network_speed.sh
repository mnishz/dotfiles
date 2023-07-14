#!/bin/bash
set -eu

get_rx_byte_size () {
    cat /proc/net/dev | grep eth0 | awk '{print $2}'
}

get_tx_byte_size () {
    cat /proc/net/dev | grep eth0 | awk '{print $10}'
}

print_human_readable () {
    local giga=$((1024*1024*1024))
    local mega=$((1024*1024))
    local kilo=1024
    if [[ $1 -ge $giga ]]; then
        echo $(($1 / $giga)) GB/s
    elif [[ $1 -ge $mega ]]; then
        echo $(($1 / $mega)) MB/s
    elif [[ $1 -ge $kilo ]]; then
        echo $(($1 / $kilo)) KB/s
    else
        echo $1 B/s
    fi
}

prev_rx=$(get_rx_byte_size)
prev_tx=$(get_tx_byte_size)

while true
do
    sleep 1
    curr_rx=$(get_rx_byte_size)
    curr_tx=$(get_tx_byte_size)
    echo "$(LANG=C date)    RX: $(print_human_readable $(($curr_rx - $prev_rx))), TX: $(print_human_readable $(($curr_tx - $prev_tx)))"
    prev_rx=$curr_rx
    prev_tx=$curr_tx
done
