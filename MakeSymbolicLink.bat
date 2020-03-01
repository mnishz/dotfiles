@echo off

if %~dp0 == %USERPROFILE%\dotfiles\ (
    set windows=true
) else (
    set windows=false
)

mklink %~dp0..\.vimrc %~dp0.vimrc
mklink %~dp0..\.gitconfig %~dp0.gitconfig
mklink %~dp0..\.minttyrc %~dp0.minttyrc
mklink %~dp0..\.tigrc %~dp0.tigrc
rem mklink %~dp0..\.git_prompt.sh %~dp0.git_prompt.sh

if %windows% == true (
    mklink /d %~dp0..\vimfiles %~dp0.vim
    mklink %~dp0..\.gvimrc %~dp0.gvimrc
    mklink %~dp0..\git_clean.sh %~dp0git_clean.sh
) else (
    mklink %~dp0..\.bashrc.additional %~dp0.bashrc.additional
    mklink /d %~dp0..\.vim %~dp0.vim
    mklink %~dp0..\bin\git_clean.sh %~dp0git_clean.sh
    mklink %~dp0..\.gdbinit %~dp0.gdbinit
    mklink %~dp0..\.tmux.conf %~dp0.tmux.conf
)
