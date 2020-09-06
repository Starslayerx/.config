""""""""""""""""vim basic config""""""""""""""""""
set nu
set t_Co=256
set nobackup
syntax on
set tabstop=4
set softtabstop=4
set scrolloff=4
set shiftwidth=4
set expandtab
set showcmd
set autoindent
set smartindent
set cindent
set encoding=utf-8
let loaded_matchparen=1 "取消括号高亮"
colorscheme default
inoremap ' ''<ESC>i
inoremap " ""<ESC>i
inoremap ( ()<ESC>i
inoremap [ []<ESC>i
inoremap {<CR> {<CR>}<ESC>O

""""""""light vim settings""""""""""
set laststatus=2
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ }
""""""""""""""""""""""VIM PLUGS"""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')
Plug 'itchyny/lightline.vim'
call plug#end()
