# Start configuration added by Zim install {{{
#
# User configuration sourced by interactive shells
#

# -----------------
# Zsh configuration
# -----------------

#
# History
#

# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS

#
# Input/output
#

# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -e

# Prompt for spelling correction of commands.
#setopt CORRECT

# Customize spelling correction prompt.
#SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}

# -----------------
# Zim configuration
# -----------------

# Use degit instead of git as the default tool to install and update modules.
#zstyle ':zim:zmodule' use 'degit'

# --------------------
# Module configuration
# --------------------

#
# git
#

# Set a custom prefix for the generated aliases. The default prefix is 'G'.
#zstyle ':zim:git' aliases-prefix 'g'

#
# input
#

# Append `../` to your input for each `.` you type after an initial `..`
#zstyle ':zim:input' double-dot-expand yes

#
# termtitle
#

# Set a custom terminal title format using prompt expansion escape sequences.
# See http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Simple-Prompt-Escapes
# If none is provided, the default '%n@%m: %~' is used.
#zstyle ':zim:termtitle' format '%1~'

#
# zsh-autosuggestions
#

# Disable automatic widget re-binding on each precmd. This can be set when
# zsh-users/zsh-autosuggestions is the last module in your ~/.zimrc.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Customize the style that the suggestions are shown with.
# See https://github.com/zsh-users/zsh-autosuggestions/blob/master/README.md#suggestion-highlight-style
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

#
# zsh-syntax-highlighting
#

# Set what highlighters will be used.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Customize the main highlighter styles.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md#how-to-tweak-it
#typeset -A ZSH_HIGHLIGHT_STYLES
#ZSH_HIGHLIGHT_STYLES[comment]='fg=242'

# ------------------
# Initialize modules
# ------------------

ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi
# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
# Initialize modules.
source ${ZIM_HOME}/init.zsh

# ------------------------------
# Post-init module configuration
# ------------------------------

#
# zsh-history-substring-search
#

zmodload -F zsh/terminfo +p:terminfo
# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
for key ('^[[A' '^P' ${terminfo[kcuu1]}) bindkey ${key} history-substring-search-up
for key ('^[[B' '^N' ${terminfo[kcud1]}) bindkey ${key} history-substring-search-down
for key ('k') bindkey -M vicmd ${key} history-substring-search-up
for key ('j') bindkey -M vicmd ${key} history-substring-search-down
unset key
# }}} End configuration added by Zim install

# >>> Homebrew Apple Silicon shell env
eval "$(/opt/homebrew/bin/brew shellenv)"
# <<<

# PATH 扩展
export PATH="/usr/local/mysql/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/curl/bin:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export PATH="/Library/Frameworks/Python.framework/Versions/3.12/bin:$PATH"
export PATH="~/.local/bin/:$PATH"

# 编译器/开发环境配置
export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include -I/opt/homebrew/opt/llvm/include -I/opt/homebrew/opt/curl/include"
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib -L/opt/homebrew/opt/curl/lib"
export PKG_CONFIG_PATH="/opt/homebrew/opt/curl/lib/pkgconfig"

# pg
export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
# export CPPFLAGS="-I/opt/homebrew/opt/postgresql@17/include"
# export LDFLAGS="-L/opt/homebrew/opt/postgresql@17/lib"

# Toolchain
export TOOLCHAINS=swift

# Editor
export VISUAL=nvim
export EDITOR=nvim

# 代理 alias
alias pc="proxychains4"

# 开启代理
alias setproxy="export all_proxy=socks5://127.0.0.1:7897; \
                export http_proxy=http://127.0.0.1:7897; \
                export https_proxy=http://127.0.0.1:7897"
alias set_git_proxy="git config --global http.proxy http://127.0.0.1:7897 && git config --global https.proxy http://127.0.0.1:7897"

# 关闭代理
alias unsetproxy="unset all_proxy http_proxy https_proxy"
alias unset_git_proxy="git config --global --unset http.proxy && git config --global --unset https.proxy"


# Git 代理
alias git_proxy_http="git config --global http.proxy 'http://192.168.0.1:7897'"
alias git_proxy_https="git config --global http.proxy 'https://192.168.0.1:7897'"
alias git_proxy_socks="git config --global http.proxy 'socks5://127.0.0.1:7897'"
alias git_unset_http_proxy="git config --global --unset http.proxy"
alias git_unset_https_proxy="git config --global --unset https.proxy"

# Homebrew 镜像源（清华）
export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
export HOMEBREW_PIP_INDEX_URL="https://pypi.tuna.tsinghua.edu.cn/simple"

# 常用 alias
alias brew="arch -arm64 brew"
alias v="nvim"
alias g++="g++ --std=c++11"
alias clang++="clang++ --std=c++11"
alias c="clear"
alias f="fg"
alias s="fastfetch"

alias gs="git log --graph --oneline --all --decorate"

# rust alternatives
# alias ls="exa"
# alias grep="rg"
# alias cat="bat"
# alias find="fd"
# alias cd="z"
# alias top="btm"
# alias ps="procs"


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/starslayerx/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/starslayerx/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/starslayerx/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/starslayerx/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# Django commadns
alias run_server='python manage.py runserver 0.0.0.0:80'

# zsh Chinese
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# python
alias python=python3

# export PYENV_ROOT="$HOME/.pyenv"
# [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init - bash)"

. "$HOME/.local/bin/env"
UV_PYTHON=/Library/Frameworks/Python.framework/Versions/3.12/bin/python3

# Command to chang arch to arm64
# arch -arm64 $SHELL

# add sqlite into path
export PATH="/opt/homebrew/opt/sqlite/bin:$PATH"
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/starslayerx/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

fpath+=${ZDOTDIR:-~}/.zsh_functions

# zoxide replace cd
eval "$(zoxide init zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Mac OS alias
alias typora='open -a Typora'
alias wps='open -a wpsoffice'

# Tmux 智能启动
alias tm='~/.local/bin/tmux-smart-start.sh'

# ----------------------------------
# 自动激活/退出 Python 虚拟环境
# ----------------------------------
auto_activate_venv() {
    # 先查找当前目录最近的虚拟环境（向上最多 3 层）
    local target_venv=""
    local dir="$PWD"
    local count=0
    while [[ "$dir" != "/" && "$dir" != "" && $count -lt 3 ]]; do
        for venv_name in .venv venv env; do
            if [[ -f "$dir/$venv_name/bin/activate" ]]; then
                target_venv="$dir/$venv_name"
                break 2  # 找到最近的就退出两层循环
            fi
        done
        dir="${dir:h}"
        ((count++))
    done

    # 如果当前已在虚拟环境中
    if [[ -n "$VIRTUAL_ENV" ]]; then
        # 如果找到的虚拟环境和当前激活的相同，无需操作
        if [[ "$VIRTUAL_ENV" == "$target_venv" ]]; then
            return
        fi
        # 否则，退出当前虚拟环境
        if typeset -f deactivate >/dev/null; then
            deactivate
        fi
    fi

    # 激活找到的虚拟环境
    if [[ -n "$target_venv" && -f "$target_venv/bin/activate" ]]; then
        source "$target_venv/bin/activate"
    fi
}

# 注册到目录切换 hook
autoload -Uz add-zsh-hook
add-zsh-hook chpwd auto_activate_venv

# shell 启动时也检查一次（适用于 tmux 恢复等场景）
auto_activate_venv
