if [ -e ~/bin/vim ]; then
    export EDITOR=~/bin/vim
else
    export EDITOR=vim
fi

alias ll='ls -lhFv'
alias la='ls -lAFv'
alias trash='gio trash'
alias smile='vim --clean -c "smile | call getchar() | q"'
alias echoroot='realpath --relative-to=. $(git rev-parse --show-toplevel)'
alias cdroot='cd $(echoroot)'
alias mydate='date "+%Y%m%d"'

alias gs='git status'
alias gg='git log --graph -C -M --pretty=format:"%C(auto)%h %cd [%an]%d %s" --date=format:"%Y/%m/%d %H:%M"'
alias ggoh='git log --graph -C -M --pretty=format:"%C(auto)%h %cd [%an]%d %s" --date=format:"%Y/%m/%d %H:%M" origin/$(git_firm_generation) HEAD'

vimt() {
    local FILE=$(readlink -f ${1})
    if [ ${VIM_TERMINAL} ]; then
        echo -e "\x1b]51;[\"drop\", \"${FILE}\"]\x07"
    else
        vim ${FILE}
    fi
}

git_check_remote() {
    # if any, fetch first
    if [ ${1} ]; then
        fetch_target=$(git rev-parse --abbrev-ref HEAD@{upstream} | sed "s/\// /")
        echo "fetching ${fetch_target}..."
        git fetch ${fetch_target}
    fi
    git graph HEAD $(git rev-parse --abbrev-ref HEAD@{upstream})
}

git_worktree_checkout() {
    if [ ${#} != 1 ] && [ ${#} != 2 ]; then
        echo 'How to use: git_worktree_checkout existing_branch_name {directory_name: optional}'
        return 1
    fi
    cdroot
    CURR_DIR_NAME=$(basename $(pwd))
    if [ ${#} == 1 ]; then
        git worktree add ../${CURR_DIR_NAME}_worktree_${1} ${1}
    else
        git worktree add ../${CURR_DIR_NAME}_worktree_${2} ${1}
    fi
    if [ ${?} == 0 ]; then
        return 0
    else
        return 1
    fi
}

git_worktree_delete() {
    if [ ${#} != 1 ]; then
        echo 'How to use: git_worktree_delete existing_branch_name'
        return 1
    fi
    CURR_DIR_NAME=$(basename $(pwd))
    if [ ! -e ${1} ]; then
        echo "Directory doesn't exist."
        return 1
    fi
    dirname=${1}
    if [ ${dirname: -1} == / ]; then
        dirname=${dirname:0:-1}
    fi
    if [ ${dirname:0:3} == ../ ]; then
        dirname=${dirname:3}
    fi
    echo $dirname
    git worktree list | grep /$dirname
    if [ ${?} != 0 ]; then
        echo "Directory doesn't belong to this repository."
        return 0
    fi
    rm -rf ${1}
    git worktree prune
    return 0
}

git_clean() {
    gitroot=$(git rev-parse --show-toplevel)
    targetdirs=$(find ${gitroot} -maxdepth 1 -type d)

    for dir in ${targetdirs};
    do
        if [ ${dir} == ${gitroot} ]; then continue; fi
        if [ ${dir} == "${gitroot}/.git" ]; then continue; fi
        if [[ ${dir} =~ ${gitroot}/worktree_.* ]]; then continue; fi
        #     echo ${dir}
        git clean ${dir} -xdff --exclude=compile_commands.json
    done
}

type "tree" > /dev/null 2>&1
if [ $? != 0 ]; then
    alias tree='pwd;find . | sort | sed '\''1d;s/^\.//;s/\/\([^/]*\)$/|--\1/;s/\/[^/|]*/|  /g'\'''
fi

type "__git_ps1" > /dev/null 2>&1
if [ $? != 0 ]; then
    if [ -f /c/msys64/usr/share/git/completion/git-prompt.sh ]; then
        source /c/msys64/usr/share/git/completion/git-prompt.sh
    fi
    if [ -f /c/msys64/usr/share/git/completion/git-completion.bash ]; then
        source /c/msys64/usr/share/git/completion/git-completion.bash
    fi
fi

export PROMPT_COMMAND=__prompt_command

function __prompt_command() {
    local EXIT="$?"

    if [ -e /var/run/reboot-required ]; then
        echo -e "\e[33m*** System restart required ***\e[m"
    fi

    local RCol='\[\e[0m\]'
    local Green='\[\e[0;32m\]'
    local Red='\[\e[0;31m\]'
    local Yellow='\[\e[0;33m\]'
    local Cyan='\[\e[0;36m\]'

    export PS1="\w${Cyan}$(__git_ps1 ' (%s)')${RCol}\$ "

    if [[ ${EXIT} == 0 ]]; then
        export PS1="${Green}✅${RCol} "$PS1
    elif [[ ${EXIT} == 130 ]]; then
        export PS1="${Red}🚫${RCol} "$PS1
    else
        export PS1="${Yellow}💥${RCol} "$PS1
    fi

    if [ -n "$SSH_CONNECTION" ]; then
        export PS1="${Red}(SSH)${RCol} "$PS1
    fi

    if [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]; then
        export PS1="${Red}(WSL)${RCol} "$PS1
    fi
}

# I'm not sure, but this doesn't work. Change .bashrc itself.
# export HISTSIZE=1000000
# export HISTFILESIZE=1000000
export HISTIGNORE=ls:ll:la
export HISTCONTROL=ignoreboth
export HISTTIMEFORMAT='%y/%m/%d %H:%M:%S '
export LS_COLORS="di=01;94"

if [[ -t 0 ]]; then
    stty stop undef
    stty start undef
fi

# export LESS="-iMRF"

if [ -f ~/.bashrc.local ]; then
    source ~/.bashrc.local
fi
