if exists('+termguicolors')
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif
""" vim config
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
set laststatus=2

set tabstop=4
set shiftwidth=4
set guifont=Hack:h16
set guifontwide=Hack:h16
"set guifont=Hack\ Regular\ Nerd\ Font\ Complete\ 16
"set guifontwide =Hack\ Regular\ Nerd\ Font\ Complete\ 16
filetype plugin indent on
set fenc=utf-8
set encoding=utf-8
set scrolloff=15 
%retab!
syntax on





""" vim plugs
call plug#begin('~/.config/nvim/plugged')

""" lightline
Plug 'itchyny/lightline.vim'

" themes
Plug 'arcticicestudio/nord-vim'

""" vim tools
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'tpope/vim-surround'
Plug 'gcmt/wildfire.vim'

""" code complete
Plug 'neoclide/coc.nvim', {'branch': 'release'}

""" nerd font
Plug 'ryanoasis/vim-devicons'

""" start screen
Plug 'mhinz/vim-startify'

call plug#end()





""" nord theme config
let g:nord_cursor_line_number_background = 1
let g:nord_uniform_status_lines = 1
let g:nord_bold_vertical_split_line = 1
let g:nord_uniform_diff_background = 1
let g:nord_italic_comments = 1
let g:nord_underline = 1
let g:nord_bold = 1
let g:nord_italic = 1
colorscheme nord


let g:lightline = {
      \ 'colorscheme': 'nord',
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ 'component': {
      \   'charvaluehex': '0x%B'
      \ },
      \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
      \ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" },
      \ }


""" coc
let g:coc_disable_startup_warning = 1
let g:coc_global_extensions = ['coc-json', 'coc-pairs', 'coc-clangd', 'coc-pyright', 'coc-go', 'coc-html', 'coc-sh', 'coc-css', 'coc-highlight', 'coc-xml', 'coc-yaml', 'coc-snippets']
set updatetime=300
set shortmess+=c
set hidden
set nobackup
set nowritebackup
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif
" snippets
let g:coc_snippet_next = '<tab>'
let g:coc_snippet_prev = '<c-b>'
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" Highlight reference
autocmd CursorHold * silent call CocActionAsync('highlight')
