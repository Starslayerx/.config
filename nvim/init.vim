" __  ____   __  _   ___     __ __ __  __ ____   ____
"|  \/  \ \ / / | \ | \ \   / /_ _|  \/  |  _ \ / ___|
"| |\/| |\ V /  |  \| |\ \ / / | || |\/| | |_) | |
"| |  | | | |   | |\  | \ V /  | || |  | |  _ <| |___
"|_|  |_| |_|   |_| \_|  \_/  |___|_|  |_|_| \_\\____|
"


" ====================
" === Editor Setup ===
" ====================
" ===
" === System
" ===
"set clipboard=unnamedplus
let &t_ut=''
set autochdir
set encoding=utf-8

" ===
" === Editor behavior
" ===
set signcolumn=yes " 左侧一直显示(给提示内容留位置) "
set exrc
set secure
set number
set relativenumber
set cursorline
set hidden
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smartindent
"set autoindent
"set cindent
set list
set listchars=tab:\ \ ,trail:▫
"set listchars=tab:\ \ ,trail:·
"set listchars=tab:\|\ ,trail:▫
set scrolloff=8
set ttimeoutlen=0
set notimeout
set viewoptions=cursor,folds,slash,unix
set wrap
set tw=0
set indentexpr=
set foldmethod=indent
set foldlevel=99
set foldenable
autocmd FileType * setlocal formatoptions-=cro " 禁用自动注释 "
set splitright
set splitbelow
set noshowmode
set showcmd
set wildmenu
set ignorecase
set smartcase
set shortmess+=c
set inccommand=split
set completeopt=longest,noinsert,menuone,noselect,preview
set ttyfast "should make scrolling faster
set lazyredraw "same as above
set visualbell

" 禁用交换文件
set nobackup
set nowritebackup
set noswapfile

silent !mkdir -p $HOME/.config/nvim/tmp/backup
silent !mkdir -p $HOME/.config/nvim/tmp/undo
"silent !mkdir -p $HOME/.config/nvim/tmp/sessions
set backupdir=$HOME/.config/nvim/tmp/backup,.
set directory=$HOME/.config/nvim/tmp/backup,.
if has('persistent_undo')
	set undofile
	set undodir=$HOME/.config/nvim/tmp/undo,.
endif
set colorcolumn=100
set updatetime=100
set virtualedit=block

au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif


" ===
" === Terminal Behaviors
" ===
let g:neoterm_autoscroll = 1
autocmd TermOpen term://* startinsert
tnoremap <C-N> <C-\><C-N>
tnoremap <C-O> <C-\><C-N><C-O>

" ===
" === Basic Mappings
" ===
let mapleader=" "

" Save & quit
noremap Q :q<CR>
noremap S :w<CR>

" Open the vimrc file anytime
noremap <LEADER>rc :e $HOME/.config/nvim/init.vim<CR>
noremap <LEADER>rv :e .nvimrc<CR>

" Make Y copy to system clipboard
noremap Y ggVG"+y

" Indentation
nnoremap < <<
nnoremap > >>

" Delete find pair
nnoremap dy d%

" Search un-highlight
noremap <LEADER><CR> :nohlsearch<CR>

" Space to Tab
"nnoremap <LEADER>tt :%s/	/\t/g
"vnoremap <LEADER>tt :s/	/\t/g

" Folding
noremap <silent> <LEADER>o za

" K/J keys for 5 times u/e (faster navigation)
noremap <silent> K 5k
noremap <silent> J 5j

" H key: go to the start of the line
noremap <silent> H I<ESC>l
" L key: go to the end of the line
noremap <silent> L A<ESC>

" Faster in-line navigation
noremap W 5w
noremap B 5b

" Ctrl + U or E will move up/down the view port without moving the cursor
noremap <C-U> 5<C-y>
noremap <C-E> 5<C-e>


" ===
" === Insert Mode Cursor Movement
" ===
inoremap <C-f> <ESC>A
inoremap <C-l> <ESC>la
"inoremap <C-h> <ESC>i
inoremap <C-b> <ESC>i




" ===
" === Command Mode Cursor Movement
" ===
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <M-b> <S-Left>
cnoremap <M-w> <S-Right>


" ===
" === Window management
" ===
" Use <space> + new arrow keys for moving the cursor around windows
noremap mw <C-w>w
noremap mk <C-w>k
noremap mj <C-w>j
noremap mh <C-w>h
noremap ml <C-w>l
noremap qf <C-w>o

" split the screens to up (horizontal), down (horizontal), left (vertical), right (vertical)
noremap <leader>k :set nosplitbelow<CR>:split<CR>:set splitbelow<CR>
noremap <leader>j :set splitbelow<CR>:split<CR>
noremap <leader>h :set nosplitright<CR>:vsplit<CR>:set splitright<CR>
noremap <leader>l :set splitright<CR>:vsplit<CR>

" Place the two screens up and down
noremap <leader>s <C-w>t<C-w>K
" Place the two screens side by side
noremap <leader>v <C-w>t<C-w>H

" Press <SPACE> + q to close the window below the current window
noremap <leader>q <C-w>j:q<CR>



" ===
" === Tab management
" ===
" Create a new tab with tn
noremap tn :tabe<CR>
noremap tN :tab split<CR>
" Move around tabs with tn and ti
noremap th :-tabnext<CR>
noremap tl :+tabnext<CR>
" Move the tabs with tmn and tmi
noremap tmh :-tabmove<CR>
noremap tml :+tabmove<CR>


" ===
" === Other useful stuff
" ===
" Open a new instance of st with the cwd
nnoremap \t :tabe<CR>:-tabmove<CR>:term sh -c 'st'<CR><C-\><C-N>:q<CR>

" Opening a terminal window
noremap <LEADER>/ :set splitbelow<CR>:split<CR>:res +10<CR>:term<CR>

" Spelling Check with <space>sc
noremap <LEADER>sc :set spell!<CR>

" Press ` to change case (instead of ~)
noremap ` ~

noremap <C-c> zz

" Auto change directory to current dir
autocmd BufEnter * silent! lcd %:p:h

" Call figlet
noremap tx :r !figlet

" find and replace
noremap \s :%s//g<left><left>

" set wrap
noremap <LEADER>sw :set wrap<CR>

" press f10 to show hlgroup
function! SynGroup()
	let l:s = synID(line('.'), col('.'), 1)
	echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun
map <F10> :call SynGroup()<CR>

" Compile function
noremap <leader>t :call CompileRunGcc()<CR>
func! CompileRunGcc()
	exec "w"
	if &filetype == 'c'
		set splitbelow
        :sp
		:term gcc -ansi -Wall % -o a.out && time ./a.out
		"term gcc -ansi -Wall % -o %< && time ./%<
    elseif &filetype == 'cpp'
		set splitbelow
		exec "!g++ -std=c++11 % -Wall -o a.out"
		"exec "!g++ -std=c++11 % -Wall -o %<"
		:sp
		":res -8
		:term ./a.out
	elseif &filetype == 'cs'
		set splitbelow
		silent! exec "!mcs %"
		:sp
		:res -5
		:term mono %<.exe
	elseif &filetype == 'java'
		set splitbelow
		:sp
		:res -5
		term javac % && time java %<
	elseif &filetype == 'sh'
		:!time bash %
	elseif &filetype == 'python'
		set splitbelow
		:sp
		:term python3 %
	elseif &filetype == 'html'
		silent! exec "!".g:mkdp_browser." % &"
	elseif &filetype == 'markdown'
		exec "InstantMarkdownPreview"
	elseif &filetype == 'tex'
		silent! exec "VimtexStop"
		silent! exec "VimtexCompile"
	elseif &filetype == 'dart'
		exec "CocCommand flutter.run -d ".g:flutter_default_device." ".g:flutter_run_args
		silent! exec "CocCommand flutter.dev.openDevLog"
	elseif &filetype == 'javascript'
		set splitbelow
		:sp
		:term export DEBUG="INFO,ERROR,WARNING"; node --trace-warnings .
	elseif &filetype == 'go'
		set splitbelow
		:sp
		:term go run .
	endif
endfunc

" ===
" === Install Plugins with Vim-Plug
" ===

call plug#begin('$HOME/.config/nvim/plugged')

" Pretty Dress
"Plug 'theniceboy/nvim-deus'
Plug 'arcticicestudio/nord-vim'

" Status line
Plug 'Starslayerx/eleline.vim'
Plug 'ojroques/vim-scrollstatus'

" snippets
Plug 'Starslayerx/vim-snippets'

" tabline & visual enhancement
Plug 'luochen1990/rainbow'
Plug 'mg979/vim-xtabline'
Plug 'ryanoasis/vim-devicons'
Plug 'wincent/terminus'

" General Highlighter
Plug 'RRethy/vim-hexokinase', { 'do': 'make hexokinase' } " color display
Plug 'RRethy/vim-illuminate' " highlight same words

" File navigation
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Editor Enhancement
Plug 'jiangmiao/auto-pairs'
Plug 'mg979/vim-visual-multi'
Plug 'tomtom/tcomment_vim' " in <space>cn to comment a line
Plug 'tpope/vim-surround' " type yskw' to wrap the word with '' or type cs'` to change 'word' to `word`
Plug 'gcmt/wildfire.vim' " in Visual mode, type k' to select all text in '', or type k) k] k} kp
Plug 'junegunn/vim-after-object' " da= to delete what's after =
Plug 'godlygeek/tabular' " ga, or :Tabularize <regex> to align
Plug 'tpope/vim-capslock'	" Ctrl+L (insert) to toggle capslock

" code complete
Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'dense-analysis/ale'

" Snippets
Plug 'SirVer/ultisnips'

" Go
Plug 'fatih/vim-go' , { 'for': ['go', 'vim-plug'], 'tag': '*' }

" Python
Plug 'Vimjas/vim-python-pep8-indent', { 'for' :['python', 'vim-plug'] } " pep8 style py

call plug#end()

set re=0

" ===
" === Dress up my vim
" ===
set termguicolors " enable true colors support
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
"set background=dark
"let ayucolor="mirage"
"let g:oceanic_next_terminal_bold = 1
"let g:oceanic_next_terminal_italic = 1
"let g:one_allow_italics = 1

color nord
"color deus
"color gruvbox
"let ayucolor="light"
"color ayu
"set background=light
"set cursorcolumn

hi NonText ctermfg=gray guifg=grey10
"hi SpecialKey ctermfg=blue guifg=grey70



" ===================== Start of Plugin Settings =====================

" ===
" === ale
" ===
"let g:ale_sign_column_always = 1
"let g:ale_sign_error = "\uf467"
"let g:ale_sign_warning = "\uf071"

" ===
" === coc.nvim
" ===
let g:coc_global_extensions = [
	\ 'coc-css',
	\ 'coc-tailwindcss',
	\ 'coc-html',
	\ 'coc-java',
	\ 'coc-json',
	\ 'coc-pyright',
	\ 'coc-vimlsp',
	\ 'coc-prisma',
	\ 'coc-docker',
	\ 'coc-eslint',
	\ 'coc-omnisharp',
	\ 'coc-sourcekit',
	\ 'coc-stylelint',
	\ 'coc-tsserver',
	\ 'coc-vetur',
    \ 'coc-sourcekit',
    \
	\ 'coc-syntax',
	\ 'coc-tasks',
	\ 'coc-prettier',
	\ 'coc-explorer',
	\ 'coc-diagnostic',
	\ 'coc-gitignore',
	\ 'coc-import-cost',
	\ 'coc-translator',
    \
	\ 'coc-lists',
	\ 'coc-snippets',
    \
	\ 'coc-yaml',
	\ 'coc-yank']

let g:coc_disable_startup_warning = 1

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
"nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" highlight
autocmd CursorHold * silent call CocActionAsync('highlight')

" Ultisnips
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" coc-snippets
"imap <C-l> <Plug>(coc-snippets-expand)
vmap <C-y> <Plug>(coc-snippets-select)
let g:coc_snippet_next = '<Nul>'
let g:coc_snippet_prev = '<Nul>'
imap <C-e> <Plug>(coc-snippets-expand-jump)
let g:snips_author = 'Starslayerx'
autocmd BufRead,BufNewFile tsconfig.json set filetype=jsonc



" explorer
nmap tt <Cmd>CocCommand explorer<CR>

" ===
" === FZF
" ===
nnoremap <c-p> :<c-u>FZF<CR>
noremap <silent> <C-f> :Rg<CR>
noremap <silent> <C-h> :History<CR>
noremap <silent> <C-b> :Buffers<CR>
noremap <leader>; :History:<CR>

let g:fzf_preview_window = 'right:60%'
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

function! s:list_buffers()
  redir => list
  silent ls
  redir END
  return split(list, "\n")
endfunction

function! s:delete_buffers(lines)
  execute 'bwipeout' join(map(a:lines, {_, line -> split(line)[0]}))
endfunction

let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8 } }


" ===
" === rainbow
" ===
let g:rainbow_active = 0


" ===
" === xtabline
" ===
let g:xtabline_settings = {}
let g:xtabline_settings.enable_mappings = 0
let g:xtabline_settings.tabline_modes = ['tabs', 'buffers']
let g:xtabline_settings.enable_persistance = 0
let g:xtabline_settings.last_open_first = 1


" ===
" === terminus
" ===
let g:TerminusMouse=0 " disable mouse


" ===================== End of Plugin Settings =====================







" ===
" === Terminal Colors
" ===

let g:terminal_color_0  = '#000000'
let g:terminal_color_1  = '#FF5555'
let g:terminal_color_2  = '#50FA7B'
let g:terminal_color_3  = '#F1FA8C'
let g:terminal_color_4  = '#BD93F9'
let g:terminal_color_5  = '#FF79C6'
let g:terminal_color_6  = '#8BE9FD'
let g:terminal_color_7  = '#BFBFBF'
let g:terminal_color_8  = '#4D4D4D'
let g:terminal_color_9  = '#FF6E67'
let g:terminal_color_10 = '#5AF78E'
let g:terminal_color_11 = '#F4F99D'
let g:terminal_color_12 = '#CAA9FA'
let g:terminal_color_13 = '#FF92D0'
let g:terminal_color_14 = '#9AEDFE'

let g:nordcolor_polar_night1 = '#2E3440'
let g:nordcolor_polar_night2 = '#3B4252'
let g:nordcolor_polar_night3 = '#434C5E'
let g:nordcolor_polar_night4 = '#4C566A'
let g:nordcolor_snow1 = '#D8DEE9'
let g:nordcolor_snow2 = '#E5E9F0'
let g:nordcolor_snow3 = '#ECEFF4'
let g:nordcolor_frost1 = '#8FBCBB'
let g:nordcolor_frost2 = '#88C0D0'
let g:nordcolor_frost3 = '#81A1C1'
let g:nordcolor_frost4 = '#5E81AC'
let g:nordcolor_aurora1 = '#BF616A'
let g:nordcolor_aurora2 = '#D08770'
let g:nordcolor_aurora3 = '#EBCB8B'
let g:nordcolor_aurora4 = '#A3BE8C'
let g:nordcolor_aurora5 = '#B48EAD'

" ===
" === Necessary Commands to Execute
" ===
exec "nohlsearch"


" opacity 透明
autocmd vimenter * hi Normal guibg=NONE ctermbg=NONE " transparent bg

