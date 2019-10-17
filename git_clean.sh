#!/bin/bash

set -eu
dirs=$(find . -maxdepth 1 -type d)

for dir in ${dirs};
do
    if [ ${dir} != '.' ]; then
        # echo ${dir}
        git clean ${dir} -xdff
    fi
done
