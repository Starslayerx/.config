return {
  -- neovim LSP client
  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" },
    opts = {
      servers = {
        pyright = {},
        lua_ls = {
          settings = {
            Lua = {
              runtime = {
                version = "LuaJIT",
              },
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = {
                enable = false,
              },
            },
          },
        },
        clangd = {},
        gopls = {},
      },
    },

    config = function(_, opts)
      -- blink.cmp 代码补全
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- 遍历所有配置的服务器
      local lspconfig = require("lspconfig")
      for server, config in pairs(opts.servers) do
        local cfg = vim.tbl_deep_extend("force", { capabilities = capabilities }, config or {})
        lspconfig[server].setup(cfg)
      end

      -- 诊断信息配置
      -- 放在 LSP config 的最前面（确保在 vim.diagnostic.config 之前）
      -- 定义 gutter 中的 DiagnosticSign
      local diagnostic_signs = {
        Error = "✖", -- 你也可以改成你常用的图标
        Warn = "⚠",
        Hint = "",
        Info = "",
      }
      for type, icon in pairs(diagnostic_signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(
          "DiagnosticSignError",
          { text = "✖", texthl = "DiagnosticSignError", numhl = "DiagnosticSignError" }
        )

        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      -- 强制打开 signcolumn（方便调试和避免抖动）
      vim.o.signcolumn = "yes"

      -- 诊断配置：不要把 signs 设成空格，直接启用 signs = true
      vim.diagnostic.config({
        virtual_text = false, -- 还是交给 tiny-inline-diagnostic
        signs = true, -- <-- 关键：启用 sign，图标由上面 sign_define 控制
        underline = {
          severity = { min = vim.diagnostic.severity.WARN },
        },
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "if_many",
          header = "",
          prefix = "",
          focusable = true,
          max_width = 80,
          max_height = 20,
          wrap = true,
          focus = false,
        },
      })

      -- LSP 按键映射
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts_map = { buffer = ev.buf, silent = true }

          -- 跳转（使用 Neovim 内置 LSP 函数）
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts_map) -- 跳转到定义
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts_map) -- 跳转到声明
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts_map) -- 跳转到实现
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts_map) -- 查找引用
          vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, opts_map) -- 跳转到类型定义（改成 gy 避免冲突）

          -- 文档和提示
          vim.keymap.set("n", "H", vim.lsp.buf.hover, opts_map) -- Hover 悬停文档
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts_map) -- 函数签名提示

          -- 代码操作
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts_map) -- 重命名
          vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts_map) -- Code Action 代码操作

          -- 诊断信息导航
          vim.keymap.set("n", "[d", function()
            vim.diagnostic.jump({ count = -1 })
          end, opts_map)
          vim.keymap.set("n", "]d", function()
            vim.diagnostic.jump({ count = 1 })
          end, opts_map)

          -- 查看当前行诊断详情（可选）
          vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts_map)
        end,
      })
    end,
  },

  -- LSP 服务器管理
  {
    "mason-org/mason.nvim",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "◌",
        },
      },
    },
  },

  -- LSP 服务配置
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      automatic_enable = true,
      ensure_installed = {
        "clangd", -- C / C++
        "pyright", -- Python
        "gopls", -- Go
        "eslint", -- JS / TS
        "lua_ls", -- Lua
        "rust_analyzer", -- Rust
        "marksman", -- Markdown
      },
      handlers = {
        -- 默认处理器：自动启动所有已安装的 LSP
        function(server_name)
          require("lspconfig")[server_name].setup({
            capabilities = require("blink.cmp").get_lsp_capabilities(),
          })
        end,
        -- 特殊配置的服务器
        ["lua_ls"] = function()
          require("lspconfig").lua_ls.setup({
            capabilities = require("blink.cmp").get_lsp_capabilities(),
            settings = {
              Lua = {
                runtime = { version = "LuaJIT" },
                diagnostics = { globals = { "vim" } },
                workspace = {
                  library = vim.api.nvim_get_runtime_file("", true),
                  checkThirdParty = false,
                },
                telemetry = { enable = false },
              },
            },
          })
        end,
      },
    },
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
  },

  -- Trouble info panel
  {
    "folke/trouble.nvim",
    opts = {
      height = 10,
      icons = true,
      auto_open = false,
      auto_close = true,
    },
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },

  -- tiny-inline-diagnostic - 更好的诊断显示
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    config = function()
      require("tiny-inline-diagnostic").setup({
        preset = "modern",
        options = {
          show_source = {
            enabled = true,
            if_many = true,
          },
          throttle = 20,
          softwrap = 30,
          multilines = {
            enabled = true,
            always_show = true,
          },
          show_all_diags_on_cursorline = false,
          enable_on_insert = false,
          overflow = {
            mode = "wrap",
          },
          virt_texts = {
            priority = 2048,
          },
        },
      })
    end,
  },

  -- LSP 诊断信息美化
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lspsaga").setup({
        ui = {
          border = "rounded",
        },
        lightbulb = {
          enable = false,
        },
      })
    end,
    -- 不使用 lspsaga 的快捷键，避免冲突
    keys = {},
  },

  -- Replace UI for messages, cmdline and popupmenu
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
    require("noice").setup({
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
      },
    }),
  },
}
