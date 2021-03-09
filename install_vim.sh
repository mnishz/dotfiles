#!/bin/bash
set -eu

# sudo apt install git gcc make gettext libtinfo-dev libacl1-dev libgpm-dev libtool-bin python3-dev curl
sudo apt install git gcc make libtinfo-dev libtool-bin python3-dev curl
# for GUI
# sudo apt install libxmu-dev libgtk-3-dev libxpm-dev

cd ~
git clone https://github.com/vim/vim
cd vim/src
./configure --prefix=${HOME} --with-features=huge --enable-fail-if-missing --enable-python3interp
# for GUI
# ./configure --prefix=${HOME} --with-features=huge --enable-fail-if-missing --enable-python3interp --enable-gui=gtk3 --enable-autoservername
make -j
# make test
make install
