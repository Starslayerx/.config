local opt = vim.opt
local g = vim.g

-- 全局设置
g.mapleader = " "

-- 编码和系统
opt.encoding = "utf-8"
opt.autochdir = false

-- 显示设置
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.wrap = true
opt.scrolloff = 8
opt.colorcolumn = "100"

-- 搜索设置
opt.ignorecase = false  -- 搜索区分大小写 (对应 noignorecase)
opt.smartcase = false   -- 不用智能大小写 (对应 nosmartcase)
opt.inccommand = "split"
opt.hlsearch = true

-- 缩进设置
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.autoindent = true
opt.smartindent = false  -- 禁用智能缩进 (对应 nosmartindent)
opt.cindent = false      -- 禁用 c 语言缩进 (对应 nocindent)
opt.indentexpr = ""

-- 折叠设置
opt.foldmethod = "indent"
opt.foldlevel = 99
opt.foldenable = true

-- 分割窗口
opt.splitright = true
opt.splitbelow = true

-- 显示相关
opt.showmode = false
opt.showcmd = true
opt.wildmenu = true
opt.list = true
opt.listchars = { tab = "  ", trail = "▫" }

-- 性能优化
opt.ttyfast = true
opt.lazyredraw = true
opt.updatetime = 100
opt.ttimeoutlen = 0
opt.timeout = false

-- 文件备份和历史
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.hidden = true

-- 设置备份和撤销目录
local config_dir = vim.fn.expand("$HOME/.config/nvim")
vim.fn.system("mkdir -p " .. config_dir .. "/tmp/backup")
vim.fn.system("mkdir -p " .. config_dir .. "/tmp/undo")

opt.backupdir = config_dir .. "/tmp/backup,."
opt.directory = config_dir .. "/tmp/backup,."
if vim.fn.has('persistent_undo') == 1 then
  opt.undofile = true
  opt.undodir = config_dir .. "/tmp/undo,."
end

-- 补全设置
opt.completeopt = { "longest", "noinsert", "menuone", "noselect", "preview" }

-- 其他设置
opt.virtualedit = "block"
opt.shortmess:append("c")
opt.viewoptions = "cursor,folds,slash,unix"

-- 终端相关
opt.termguicolors = true
g.terminal_emulator = "nvim"

-- 禁用自动注释
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove("c")
    vim.opt_local.formatoptions:remove("r")
    vim.opt_local.formatoptions:remove("o")
  end,
})

-- 记住光标位置
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local line = vim.fn.line("'\"")
    if line > 1 and line <= vim.fn.line("$") then
      vim.cmd("normal! g'\"")
    end
  end,
})


-- 终端设置
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "term://*",
  command = "startinsert",
})

-- 设置语法高亮
vim.cmd("syntax on")

-- 正则表达式引擎
vim.opt.re = 0
