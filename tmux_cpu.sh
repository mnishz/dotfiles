#!/bin/bash
set -eu

cpu_usage=$(top -b -n 1 | grep "%Cpu" | awk '{print $2 + $4}')
cpu_usage_int=$(echo "$cpu_usage" | awk '{print int($1)}')
cpu_usage=$(printf "%.1f" $cpu_usage)
if (( $cpu_usage_int >= 80 )); then
    echo "#[bg=yellow]${cpu_usage}#[default]"
else
    echo "${cpu_usage}"
fi
