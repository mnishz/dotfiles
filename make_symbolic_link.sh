#!/bin/bash
ln -sf ~/dotfiles/.vimrc ~/.vimrc
# ln -sf ~/dotfiles/.gvimrc ~/.gvimrc
ln -sf ~/dotfiles/.dein.toml ~/.dein.toml
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/.gdbinit ~/.gdbinit
ln -sf ~/dotfiles/.screenrc ~/.screenrc
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
# ln -sf ~/dotfiles/.minttyrc ~/.minttyrc
ln -sf ~/dotfiles/.bashrc.additional ~/.bashrc.additional
# ln -sf ~/dotfiles/.git_prompt.sh ~/.git_prompt.sh
ln -sf ~/dotfiles/git_clean.sh ~/git_clean.sh
rm ~/.vim
ln -sf ~/dotfiles/vimfiles ~/.vim
