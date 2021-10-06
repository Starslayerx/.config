## Vim Tricks
### 复制到系统剪切板
```vim
"+Y
```

### 计算表达式
在插入模式下：`<Ctrl-r>=`后面输入表达式，然后`<CR>`回车可得到计算结果

## 命令模式
| 符号 | 地址 |
| :-: | :-: |
| 1 | 第一行 |
| $ | 最后一行 |
| . | 光标所在行 |
| 'm | 位置标记为m的行 |
| '< | 可视选中起始行 |
| '> | 可视选中结束行 |
| % | 整个文件 |

### 打印行
```vim
{start}, {end}p
```
其中，start和end分别为开始与结束行，p是`print`的简写，会打印这些行  
可以通过`+-`运算修正start和end的范围(对下面同适用)    
或者也可以使用`/start/`和`/end/`两个文本来确定开始与结束  

### 替换文本
```vim
{start}, {end}s/{orgion}/{after}
```
同上，其中s是`substitue`的简写，会替换orgion文本为after  
一般常使用`%`替换整个文本

### 复制行
复制命令为`:copy`，也可以简写为`:co`或`:t`
```shell
[range] copy {address}
```



### Coc Plug Notes
- CocConfig
```json
{
    "languageserver": {
        "ccls": {
            "command": "ccls",
            "filetypes": [
                "c",
                "cc",
                "cpp",
                "objc",
                "objcpp"
            ],
            "rootPatterns": [
                ".ccls",
                "compile_commands.json",
                ".vim/",
                ".git/",
                ".hg/"
            ],
            "initializationOptions": {
                "cache": {
                    "directory": "/tmp/ccls"
                }
            }
        }
    }
}
```

- coc-clangd
```bash
  {
          "languageserver":
          {
                  "coc-clangd":
                  {
                          "command": "clangd",
                          "rootPatterns": ["compile_flags.txt",
                                          "compile_commands.json"],
                          "filetypes":["c",
                                          "cc",
                                          "cpp",
                                          "c++",
                                          "objc",
                                          "objcpp"]
                  },
                  "cmake":
                  {
                          "command": "cmake-language-server",
                          "filetypes": ["cmake"],
                          "rootPatterns": ["build/"],
                          "initializationOptions":
                          { 
                                  "buildDirectory": "build"
                          }
                  }
          }
          
  }

```

## init.vim
2021-09-28 update
```vimscript
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

""" highlight
Plug 'jackguo380/vim-lsp-cxx-highlight'
Plug 'neovim/nvim-lsp' " nvim-lsp

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
let g:coc_global_extensions = ['coc-json', 'coc-pairs', 'coc-clangd', 'coc-python', 'coc-go', 'coc-html', 'coc-sh', 'coc-css', 'coc-highlight', 'coc-xml', 'coc-yaml', 'coc-snippets', 'coc-sql', 'coc-r-lsp', 'coc-fzf-preview']

" tab trigger snippets
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
let g:coc_snippet_next = '<tab>'

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

""" highlight
let g:lsp_cxx_hl_use_text_props = 1
```
