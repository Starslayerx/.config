return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- code complection
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp

  -- Snippets
  use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
  use 'L3MON4D3/LuaSnip' -- Snippets plugin

  -- autopairs
  use 'windwp/nvim-autopairs'

  use 'kyazdani42/nvim-web-devicons'

  -- code high light
  use 'nvim-treesitter/nvim-treesitter'

  -- lightline
  use { 'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true } }

  -- nord colorscheme
  use 'shaunsingh/nord.nvim'

  -- vim surround
  use 'tpope/vim-surround'

  -- wildfire
  use 'gcmt/wildfire.vim'

  -- multi cursor
  use 'mg979/vim-visual-multi'

  -- left file tree
  use { 'kyazdani42/nvim-tree.lua' }

  -- tabline
  use {'akinsho/bufferline.nvim', requires = 'kyazdani42/nvim-web-devicons'}

  -- cursor line
  use 'yamatsum/nvim-cursorline'

  -- starup
  use {
    "startup-nvim/startup.nvim",
    requires = {"nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim"},
    config = function()
      require"startup".setup({theme = "evil"})
    end
  }

  -- indent
  use 'lukas-reineke/indent-blankline.nvim'

  -- better command mod
  use 'gelguy/wilder.nvim'

  -- comment
  use 'preservim/nerdcommenter'

  -- terminal intergration
  use {"akinsho/toggleterm.nvim"}


end)
