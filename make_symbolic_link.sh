#!/bin/bash
ln -sf ~/dotfiles/.vimrc ~/.vimrc
# ln -sf ~/dotfiles/.gvimrc ~/.gvimrc
ln -sf ~/dotfiles/.dein.toml ~/.dein.toml
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/.gdbinit ~/.gdbinit
ln -sf ~/dotfiles/.bashrc.additional ~/.bashrc.additional
ln -sf ~/dotfiles/.git_prompt.sh ~/.git_prompt.sh
rm ~/.vim
ln -sf ~/dotfiles/vimfiles ~/.vim
