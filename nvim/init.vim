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
""" lightline "
Plug 'itchyny/lightline.vim'
""" airline
"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'
" themes
Plug 'arcticicestudio/nord-vim'
Plug 'sonph/onehalf', { 'rtp': 'vim' }
""" vim tools
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'tpope/vim-surround'
Plug 'gcmt/wildfire.vim'
""" code complete
Plug 'neoclide/coc.nvim', {'branch': 'release'}
""" lsp highlight
Plug 'jackguo380/vim-lsp-cxx-highlight'
""" nerd font
Plug 'ryanoasis/vim-devicons'
""" start screen
Plug 'mhinz/vim-startify'
""" file search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'mileszs/ack.vim'
call plug#end()


""" lsp
let g:lsp_cxx_hl_use_text_props = 1

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


"let g:lightline = {
"      \ 'colorscheme': 'nord',
"      \ 'component_function': {
"      \   'filetype': 'MyFiletype',
"      \   'fileformat': 'MyFileformat',
"      \ },
"      \ 'component': {
"      \   'charvaluehex': '0x%B'
"      \ },
"      \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
"      \ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" },
"      \ }
"
"function! MyFiletype()
"  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
"endfunction
"
"function! MyFileformat()
"  return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
"endfunction

"let g:airline_theme='nord'
"""" airilne & nerd font
"let g:airline_powerline_fonts=0
"let g:webdevicons_enable_airline_tabline = 0
"let g:webdevicons_enable_airline_statusline = 0
"let g:airline#extensions#tabline#left_sep = ' '
"let g:airline#extensions#tabline#left_alt_sep = '|'
"let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#formatter = 'unique_tail_improved'


""" startify
let g:webdevicons_enable_startify = 1


""" fzf.vim
noremap <c-f> :Files<CR>
noremap <c-l> :Lines<CR>
noremap <c-b> :Buffers<CR>
noremap <c-h> :History<CR>
noremap <c-g> :Ag<CR>
let g:fzf_preview_window = 'right:60%'
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

""" ack: ag for fzf
let g:ackprg = 'ag --nogroup --nocolor --column'

""" coc
let g:coc_disable_startup_warning = 1
let g:coc_global_extensions = ['coc-json', 'coc-pairs', 'coc-clangd', 'coc-pyright', 'coc-go', 'coc-html', 'coc-sh', 'coc-css', 'coc-highlight', 'coc-xml', 'coc-yaml', 'coc-snippets', 'coc-fzf-preview']
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


""" coc.nvim
" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif
