#!/bin/bash
set -eu

sudo apt update
sudo apt install vim tmux

# ./install_vim.sh
./make_symbolic_link.sh

echo '' >> ~/.bashrc
echo 'source ~/.bashrc.additional' >> ~/.bashrc
echo 'HISTSIZE=1000000' >> ~/.bashrc
echo 'HISTFILESIZE=1000000' >> ~/.bashrc

if [ $(whoami) == 'pi' ]; then
    passwd
    # sudo raspi-config
    #     Performance Options -> Fan -> default
    #     Localisation Options -> Locale -> ja_JP.UTF-8 UTF-8
    #     Localisation Options -> Timezone -> Asia -> Tokyo
    #     System Options -> Boot
fi
