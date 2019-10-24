#!/bin/bash

set -eu
dirs=$(find $(git rev-parse --show-toplevel) -maxdepth 1 -type d)

for dir in ${dirs};
do
    if [ ${dir} != '.' ]; then
        # echo ${dir}
        git clean ${dir} -xdff
    fi
done
