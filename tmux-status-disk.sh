#!/bin/bash
set -eu

text=$(df -h | awk '$6 ~ /fw$/ {print $2 "/" $3 "/" $4}')
size=$(echo ${text} | cut -f 1 -d '/')
size=${size:0:-1}
used=$(echo ${text} | cut -f 2 -d '/')
used=${used:0:-1}
avail=$(echo ${text} | cut -f 3 -d '/')
ratio=$((${used}*100/${size}))
if (( $ratio >= 90 )); then
    echo "#[bg=red] Disk Avail: ${avail} #[default]"
else
    echo " Disk Avail: ${avail} "
fi
