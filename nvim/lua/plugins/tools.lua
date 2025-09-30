return {
  -- Wildfire: 空格选择内容
  {
    "sustech-data/wildfire.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      surrounds = {
        { "(", ")" },
        { "{", "}" },
        { "<", ">" },
        { "[", "]" },
        { '"', '"' },
        { "'", "'" },
        { "`", "`" },
      },
      keymaps = {
        init_selection = "<CR>", -- 回车开始/扩展选择
        node_incremental = "<CR>", -- 持续回车继续扩展
        node_decremental = "<BS>", -- 退格缩小选择
      },
      filetype_exclude = { "qf" }, -- 禁用的文件类型
    },
  },

  -- Formatter
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        -- 这里定义 keymap
        "<leader>F",
        function()
          require("conform").format({ async = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      -- 这里定义 Formatters
      formatters_by_ft = {
        python = { "ruff", "isort" },
        javascript = { "prettier", stop_after_first = true },
        lua = { "stylua" },
      },
      default_format_opts = {
        lsp_format = "fallback",
      },
      -- Set up format-on-save
      format_on_save = { timeout_ms = 500 },
      -- Customize formatters
      formatters = {
        shfmt = {
          append_args = { "-i", "2" },
        },
      },
    },
  },

  -- Linter
}
