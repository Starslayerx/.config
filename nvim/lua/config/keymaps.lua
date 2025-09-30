local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }


-- ===
-- === Basic Mappings
-- ===

-- Save & quit
keymap("n", "S", ":w<CR>", opts)
keymap("n", "Q", ":q<CR>", opts)

-- Make Y copy to system clipboard
keymap("n", "Y", "ggVG\"+y", opts)

-- Indentation
keymap("n", "<", "<<", opts)
keymap("n", ">", ">>", opts)

-- Search un-highlight
keymap("n", "<LEADER><CR>", ":nohlsearch<CR>", opts)

-- K/J keys for 5 times u/e (faster navigation)
keymap("n", "K", "5k", opts)
keymap("n", "J", "5j", opts)
keymap("v", "K", "5k", opts)
keymap("v", "J", "5j", opts)


-- ===
-- === Insert Mode Cursor Movement
-- ===
keymap("i", "<C-f>", "<ESC>A", opts)
keymap("i", "<C-l>", "<ESC>la", opts)
keymap("i", "<C-b>", "<ESC>i", opts)


-- ===
-- === Tab management
-- ===
-- Create new tab
keymap('n', 'tn', ':tabe<CR>', { desc = 'New tab' })
keymap('n', 'tN', ':tab split<CR>', { desc = 'Split current buffer in new tab' })

-- Move around tabs
keymap('n', 'th', ':-tabnext<CR>', { desc = 'Previous tab' })
keymap('n', 'tl', ':+tabnext<CR>', { desc = 'Next tab' })

-- Move tabs
keymap('n', 'tmh', ':-tabmove<CR>', { desc = 'Move tab left' })
keymap('n', 'tml', ':+tabmove<CR>', { desc = 'Move tab right' })


-- ===
-- === Window management
-- ===
-- 快速打开终端快捷键
vim.keymap.set('n', '<leader>t', ':split | terminal<CR>', {silent = true, desc = 'Open terminal'})
vim.keymap.set('n', '<leader>T', ':vsplit | terminal<CR>', {silent = true, desc = 'Open terminal'})
-- 终端模式下使用 ESC 退出插入模式
keymap('t', '<Esc>', '<C-\\><C-n>', {noremap = true})
-- 终端模式下用 Ctrl + 方向键切换窗口
keymap('t', '<C-h>', '<C-\\><C-n><C-w>h', {noremap = true})
keymap('t', '<C-j>', '<C-\\><C-n><C-w>j', {noremap = true})
keymap('t', '<C-k>', '<C-\\><C-n><C-w>k', {noremap = true})
keymap('t', '<C-l>', '<C-\\><C-n><C-w>l', {noremap = true})

-- 普通模式的窗口切换
keymap('n', '<C-h>', '<C-w>h', {noremap = true})
keymap('n', '<C-j>', '<C-w>j', {noremap = true})
keymap('n', '<C-k>', '<C-w>k', {noremap = true})
keymap('n', '<C-l>', '<C-w>l', {noremap = true})
