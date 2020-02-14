#!/bin/bash
set -eu

if [ $# == 0 ]; then
    dir=/
else
    dir=$1
fi

df_text=$(df -h ${dir} | awk '$6 ~ "^/" {print}')
ratio=$(echo ${df_text} | awk '{print $5}')
ratio=${ratio:0:-1}
avail=$(echo ${df_text} | awk '{print $4}')
if (( $ratio >= 90 )); then
    echo "#[bg=red]${avail}#[default]"
else
    echo "${avail}"
fi
