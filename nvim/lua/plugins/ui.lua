return {
  -- nord 主题
  {
    "gbprod/nord.nvim",
    lazy = false,
    priority = 1000,

    opts = {
      styles = {
        -- Style to be applied to different syntax groups
        -- Value is any valid attr-list value for `:help nvim_set_hl`
        comments = { italic = true },
        keywords = {},
        functions = {},
        variables = {},

        -- To customize lualine/bufferline
        bufferline = {
          current = {},
          modified = { italic = true },
        },

        lualine_bold = true, -- When `true`, section headers in the lualine theme will be bold
      },
    },
    config = function()
      require("nord").setup({})
      vim.cmd.colorscheme("nord")
    end,
  },

  -- icons 图标支持
  { "nvim-mini/mini.nvim", version = "*" },
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- 展示 key mapping
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },

  -- window picker: 快速切换窗口
  {
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    event = "VeryLazy",
    version = "2.*",
    config = function()
      require("window-picker").setup()
    end,
  },

  -- 语法高亮
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "master",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        -- 确保安装的语言列表
        ensure_installed = {
          "python",
          "javascript",
          "typescript",
          "lua",
          "go",
          "html",
          "css",
          "json",
          "yaml",
          "toml",
          "latex",
          "markdown",
          "markdown_inline",
          "dockerfile",
          "norg",
          "scss",
          "svelte",
          "tsx",
          "typst",
          "vue",
          "regex", -- need for some plugins
        },

        highlight = {
          enable = true,
          disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,
          additional_vim_regex_highlighting = false,
        },
      })
    end,
  },

  {
    -- 彩虹括号
    "HiPhish/rainbow-delimiters.nvim",
    config = function()
      require("rainbow-delimiters.setup").setup({
        strategy = {
          [""] = "rainbow-delimiters.strategy.global",
          vim = "rainbow-delimiters.strategy.local",
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
        },
        highlight = { -- 自定义括号颜色 & 渲染顺序
          "nord8",
          "FrappeBlue",
          "FrappeLavender",
          "FrappePink",
          "FrappeYellow",
          "FrappeMaroon",
          "FrappePeach",
        },
      })
      -- 定义括号颜色
      local hl = vim.api.nvim_set_hl
      -- nord color palettes
      -- Polar Night
      hl(0, "nord0", { fg = "#2E3440" })
      hl(0, "nord1", { fg = "#3B4252" })
      hl(0, "nord2", { fg = "#434C5E" })
      hl(0, "nord3", { fg = "#4C566A" })
      -- Snow-Storm
      hl(0, "nord4", { fg = "#D8DEE9" })
      hl(0, "nord5", { fg = "#E5E9F0" })
      hl(0, "nord6", { fg = "#ECEFF4" })
      -- Frost
      hl(0, "nord7", { fg = "#8FBCBB" })
      hl(0, "nord8", { fg = "#88C0D0" })
      hl(0, "nord9", { fg = "#81A1C1" })
      hl(0, "nord10", { fg = "#5E81AC" })
      -- Aurora
      hl(0, "nord11", { fg = "#BF616A" })
      hl(0, "nord12", { fg = "#D08770" })
      hl(0, "nord13", { fg = "#EBCB8B" })
      hl(0, "nord14", { fg = "#A3BE8C" })
      hl(0, "nord15", { fg = "#B48EAD" })

      -- Catppuccin Frappé
      hl(0, "FrappeRosewater", { fg = "#f2d5cf" })
      hl(0, "FrappeFlamingo", { fg = "#eebebe" })
      hl(0, "FrappePink", { fg = "#f4b8e4" })
      hl(0, "FrappeMauve", { fg = "#ca9ee6" })
      hl(0, "FrappeRed", { fg = "#e78284" })
      hl(0, "FrappeMaroon", { fg = "#ea999c" })
      hl(0, "FrappePeach", { fg = "#ef9f76" })
      hl(0, "FrappeYellow", { fg = "#e5c890" })
      hl(0, "FrappeGreen", { fg = "#a6d189" })
      hl(0, "FrappeTeal", { fg = "#81c8be" })
      hl(0, "FrappeSky", { fg = "#99d1db" })
      hl(0, "FrappeSapphire", { fg = "#85c1dc" })
      hl(0, "FrappeBlue", { fg = "#8caaee" })
      hl(0, "FrappeLavender", { fg = "#babbf1" })
      hl(0, "FrappeText", { fg = "#c6d0f5" })
    end,
    opts = {},
    git = { submodules = false }, -- 禁止 submodules
  },

  -- 展示色块
  {
    "Starslayerx/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },

  -- 状态栏
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "gbprod/nord.nvim" },
    opts = {
      options = {
        icons_enabled = true,
        theme = "nord",
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "", right = "" },
      },
    },
  },
}
