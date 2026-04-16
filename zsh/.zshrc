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
bindkey -v

# Vi 模式光标样式：普通模式使用方块，插入模式使用竖线
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'  # 方块光标
  elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ ${KEYMAP} = '' ]] || [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'  # 竖线光标
  fi
}
zle -N zle-keymap-select

# 启动时使用竖线光标
function zle-line-init {
  echo -ne '\e[5 q'
}
zle -N zle-line-init

# 每次命令执行后重置为竖线光标
preexec() {
  echo -ne '\e[5 q'
}

# 保留常用的 emacs 风格键绑定
bindkey '^A' beginning-of-line    # Ctrl-A 跳到行首
bindkey '^E' end-of-line          # Ctrl-E 跳到行尾
bindkey '^K' kill-line            # Ctrl-K 删除到行尾
bindkey '^U' backward-kill-line   # Ctrl-U 删除到行首
bindkey '^W' backward-kill-word   # Ctrl-W 删除前一个单词
bindkey '^R' history-incremental-search-backward  # Ctrl-R 反向搜索历史

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
# vi 普通模式下 j/k 只用于多行内移动，不切换历史
bindkey -M vicmd 'k' up-line
bindkey -M vicmd 'j' down-line
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
alias vscode='open -a Visual Studio Code'

# Tmux 智能启动
alias tm='~/.local/bin/tmux-smart-start.sh'

# Claude Code
alias cc='claude'
# Codex
alias co='codex -a on-request'
alias cx='codex -s danger-full-access -a on-request'

# ----------------------------------
# Oracle Instant Client 配置
# ----------------------------------
export ORACLE_HOME=~/opt/oracle/instantclient_23_3
export PATH=$ORACLE_HOME:$PATH
export DYLD_LIBRARY_PATH=$ORACLE_HOME:$DYLD_LIBRARY_PATH
export NLS_LANG=AMERICAN_AMERICA.AL32UTF8  # UTF8 编码，支持中文显示

# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
. '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

# direnv
eval "$(direnv hook zsh)"

# 修复 direnv/nix 清除 LS_COLORS 的问题
_restore_ls_colors() {
  export CLICOLOR=1
  export LS_COLORS="di=1;34:ln=35:so=32:pi=33:ex=1;31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
  alias ls='ls --color=auto'
}
add-zsh-hook precmd _restore_ls_colors

# Custom prompt symbol (override asciiship default)
_prompt_asciiship_vimode() {
  case ${KEYMAP} in
    vicmd) print -n '%S⚡%s' ;;
    *) print -n '⚡' ;;
  esac
}
PS1=${PS1% }

# unset pip source
unset HOMEBREW_PIP_INDEX_URL


# ----------------------------------
# Go Configure
# ----------------------------------
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
