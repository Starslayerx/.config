-- 禁用 Perl 提供商
vim.g.loaded_perl_provider = 0

-- 禁用 Ruby 提供商
vim.g.loaded_ruby_provider = 0

-- lazy.nvim
require("config.lazy")

-- 非插件, 自定义配置
require("config.transparency")
require("config.keymaps")
require("config.options")
