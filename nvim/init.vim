""" vim config """
set nonu
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

""inoremap ' ''<ESC>i
""inoremap " ""<ESC>i
""inoremap ( ()<ESC>i
""inoremap [ []<ESC>i
""inoremap {<CR> {<CR>}<ESC>O



""" vim plug config """
call plug#begin('~/.config/nvim/plugged')
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-fugitive'
Plug 'arcticicestudio/nord-vim'
call plug#end()


""" lightline config """
set laststatus=2

let g:lightline = {
      \ 'colorscheme': 'nord',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             ['readonly', 'filename', 'modified', 'charvaluehex' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ 'component': {
      \   'charvaluehex': '0x%B'
      \ },
      \ }
let g:lightline.separator = { 'left': '', 'right': '' }
let g:lightline.subseparator = { 'left': '|', 'right': '|' }

""" nord config """
let g:nord_cursor_line_number_background = 1
let g:nord_italic_comments = 1
let g:nord_underline = 1
let g:nord_uniform_diff_background = 1
colorscheme nord
hi Comment ctermfg=Cyan


""" vim rainbow ""
