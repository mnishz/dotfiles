#!/bin/bash
ln -sf ~/dotfiles/.vimrc ~/.vimrc
# ln -sf ~/dotfiles/.gvimrc ~/.gvimrc
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/.gdbinit ~/.gdbinit
ln -sf ~/dotfiles/.screenrc ~/.screenrc
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
# ln -sf ~/dotfiles/.minttyrc ~/.minttyrc
ln -sf ~/dotfiles/.tigrc ~/.tigrc
ln -sf ~/dotfiles/.bashrc.additional ~/.bashrc.additional
# ln -sf ~/dotfiles/.git_prompt.sh ~/.git_prompt.sh
ln -sf ~/dotfiles/git_clean.sh ~/bin/git_clean.sh
ln -sf ~/dotfiles/tmux_disk_avail.sh ~/bin/tmux_disk_avail.sh
if [ -d ~/.vim ]; then
    if [ ! -L ~/.vim ]; then
        gio trash ~/.vim
    else
        unlink ~/.vim
    fi
fi
ln -sf ~/dotfiles/.vim ~/.vim
