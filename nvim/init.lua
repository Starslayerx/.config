-- lua file only contains vim commands
require('init-vim-cmd')

-- 使用相对行号
vim.wo.number = true
vim.wo.relativenumber = true

-- 光标行高亮
vim.o.cursorline = true

-- tab设置
vim.o.shiftwidth = 4
vim.o.smartindent = true
vim.o.tabstop = 4
vim.o.expandtab = true

-- 终端样式
vim.o.termguicolors = true

-- 不可见字符的显示，这里只把空格显示为一个点
-- vim.o.list = true
-- vim.o.listchars = "space:·"

-- jk移动时光标下上方保留6行
vim.o.scrolloff = 6
vim.o.sidescrolloff = 6

-- 分屏方式
vim.o.splitbelow = true
vim.o.splitright = true

-- 鼠标支持
-- vim.o.mouse = "a"

-- 显示左侧图标指示列
vim.wo.signcolumn = "yes"

-- smaller updatetime
vim.o.updatetime = 100

-- utf8
vim.g.encoding = "UTF-8"
vim.o.fileencoding = 'utf-8'

-- <leader>键
vim.g.mapleader = '\\'

-- 补全增强
vim.o.wildmenu = true

-- 搜索大小写不敏感，除非包含大写
vim.o.ignorecase = true
vim.o.smartcase = true

-- 禁止折行
-- vim.o.wrap = false
-- vim.wo.wrap = false

-- Dont' pass messages to |ins-completin menu|
vim.o.shortmess = vim.o.shortmess .. 'c'
vim.o.pumheight = 10

vim.o.history = 200
vim.o.autoindent = true
vim.o.laststatus = 2
vim.o.showcmd = true
vim.o.visualbell = true


-- config lua files
require('init-packer')
require('init-lsp')
require('init-lualine')
require('init-vim-tree')
require('init-tabline')
require('init-terminal')
