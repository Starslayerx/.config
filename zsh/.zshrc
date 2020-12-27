# didn't add config docs like zimfw or conda.
# just config for mywon use
# If u noticed this, don't think/do anything to my server :D
alias ssh-aliyun="ssh root@120.26.176.198"
alias ssr-h="export http_proxy=http://127.0.0.1:12333"
alias ssr-hs="export https_proxy=http://127.0.0.1:12333"
alias ssr-git="git config --global http.proxy 'socks5://127.0.0.1:1080'"
alias ssr-gits="git config --global https.proxy 'socks5://127.0.0.1:1080'"

alias r='ranger'
alias c='clear'
alias s='neofetch'
alias vim='nvim'
alias matlab='sudo /usr/local/MATLAB/R2018b/bin/matlab'
alias rs="realsense-viewer"


export EDITOR="nvim"
export VISUAL="nvim"
export PATH=$PATH:/home/starslayerx/.local/bin
export PATH=$PATH:/usr/local/go/bin
export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3

# JetsonNano Config
# ssh sx@192.168.55.1
# 192.168.55.1:8888
# password::    dlinano
