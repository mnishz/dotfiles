#!/bin/bash
set -eu

sudo apt install git gcc make gettext libtinfo-dev libacl1-dev libgpm-dev libtool-bin
# sudo apt install python3-dev

cd ~
git clone https://github.com/vim/vim
cd vim/src
./configure --prefix=${HOME} --with-features=huge --enable-fail-if-missing
# ./configure --prefix=${HOME} --with-features=huge --enable-fail-if-missing --enable-python3interp
make -j
make test
make install
