""" vim config """
set nu
set showcmd
set t_Co=256
set expandtab
set nobackup
set expandtab
set cursorline
set nocompatible
set smartindent
set autoindent

set tabstop=4
set shiftwidth=4
set guifont=Hack:h14
set fenc=utf-8
set encoding=utf-8
set scrolloff=15

%retab!
syntax on

inoremap ' ''<ESC>i
inoremap " ""<ESC>i
inoremap ( ()<ESC>i
inoremap [ []<ESC>i
inoremap {<CR> {<CR>}<ESC>O


""" vim plug config """
call plug#begin('~/.vimi/plugged')
Plug 'frazrepo/vim-rainbow'
Plug 'itchyny/lightline.vim'
Plug 'arcticicestudio/nord-vim'
call plug#end()



""" lightline config """
set laststatus=2
let g:lightline = {
      \ 'colorscheme': 'nord',
      \ }



""" nord config """
colorscheme nord



""" vim rainbow config """
let g:rainbow_active = 1
let g:rainbow_load_separately = [
    \ [ '*' , [['(', ')'], ['\[', '\]'], ['{', '}']] ],
    \ [ '*.tex' , [['(', ')'], ['\[', '\]']] ],
    \ [ '*.cpp' , [['(', ')'], ['\[', '\]'], ['{', '}']] ],
    \ [ '*.cc' , [['(', ')'], ['\[', '\]'], ['{', '}']] ],
    \ [ '*.c' , [['(', ')'], ['\[', '\]'], ['{', '}']] ],
    \ [ '*.{html,htm}' , [['(', ')'], ['\[', '\]'], ['{', '}'], ['<\a[^>]*>', '</[^>]*>']] ],
    \ ]

let g:rainbow_guifgs = ['RoyalBlue3', 'DarkOrange3', 'DarkOrchid3', 'FireBrick']
let g:rainbow_ctermfgs = ['blue', 'green', 'red', 'magenta']
