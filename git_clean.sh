#!/bin/bash
set -eu

gitroot=$(git rev-parse --show-toplevel)
targetdirs=$(find ${gitroot} -maxdepth 1 -type d)

for dir in ${targetdirs};
do
    if [ ${dir} == ${gitroot} ]; then continue; fi
    if [ ${dir} == "${gitroot}/.git" ]; then continue; fi
    # echo ${dir}
    git clean ${dir} -xdff
done
