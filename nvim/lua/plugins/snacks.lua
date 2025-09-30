---@diagnostic disable: undefined-global
---@diagnostic disable: duplicate-set-field
return {
  -- Snacks: 常用插件集合, 功能混杂, 因此使用单独文件配置
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@class snacks.Config: table
    opts = { -- 这里配置要启动的插件
      bigfile = { enabled = true }, -- 大文件友好模式
      dashboard = { enabled = true }, -- 欢迎界面
      explorer = { -- 文件浏览器
        enabled = true,
        side = "left",
        replace_netrw = true,
        layout = "sidebar",
        icons = {
          enabled = true,
          provider = "devicons",
        },
      },
      image = { enabled = true, backend = "ghostty" }, -- 终端内显示图片
      input = { enabled = true }, -- 改善 vim.ui.input: 更好的弹窗、占位、样式
      notifier = { enabled = true, timeout = 3000 }, -- 更漂亮的 vim.notify 与历史
      picker = { -- like fzf or Telescope
        enabled = true,
        sources = {
          explorer = {
            auto_close = true, -- 打开文件后自动关闭 explorer
            win = {
              list = {
                keys = {
                  ["<BS>"] = "explorer_up", -- 删除键打开上级目录
                  ["h"] = "explorer_close", -- 关闭目录
                  ["<CR>"] = "confirm", -- 回车进入目录/打开文件
                  ["l"] = "tab", -- 打开文件
                  ["t"] = "tab", -- 新 tab 打开文件
                  ["s"] = "split", -- 横向分屏
                  ["v"] = "vsplit", -- 纵向分屏

                  ["o"] = false, -- 禁止使用系统工具打开文件
                  ["a"] = "explorer_add", -- 添加文件
                  ["d"] = "explorer_del", -- 删除文件
                  ["r"] = "explorer_rename", -- 重命名文件
                  ["c"] = "explorer_copy", -- 复制文件
                  ["m"] = "kexplorer_move", -- 移动文件
                  ["P"] = "toggle_preview", -- 预览文件
                  ["y"] = { "explorer_yank", mode = { "n", "x" } }, -- 复制文件路径
                  ["p"] = "explorer_paste", -- 粘贴文件: 使用上面复制即可（文件存在不会覆盖，会报错）
                  ["u"] = "explorer_update", -- 更新文件树

                  ["<leader>/"] = "picker_grep", -- 查找文件
                  ["c-t"] = "terminal", -- 打开终端（使用C-d 关闭）
                  ["."] = "explorer_focus", -- 进入文件架
                  ["I"] = "toggle_ignored", -- 显示 .gitignore 的文件
                  ["H"] = "toggle_hidden", -- 显示隐藏文件
                  ["Z"] = "explorer_close_all", -- 收起子文件夹
                  ["c-c"] = "tcd", -- 进入子文件夹
                  -- 跳转到 git 修改的文件
                  ["]g"] = "explorer_git_next",
                  ["[g"] = "explorer_git_prev",
                  -- 跳转到有诊断信息的文件
                  ["]d"] = "explorer_diagnostic_next",
                  ["[d"] = "explorer_diagnostic_prev",
                  -- 跳转到有警告信息的文件
                  ["]w"] = "explorer_warn_next",
                  ["[w"] = "explorer_warn_prev",
                  -- 跳转到有报错信息的文件
                  ["]e"] = "explorer_error_next",
                  ["[e"] = "explorer_error_prev",
                },
              },
            },
          },
        },
      },
      indent = { enabled = true }, -- 视觉化缩进线 & 范围
      scope = { enabled = true }, -- 基于 treesitter/indent 的 scope 检测
      quickfile = { enabled = true }, -- 立刻渲染文件
      scroll = { enabled = true }, -- 平滑滚动
      -- 美化状态栏 gutter: 行号左侧的东西
      statuscolumn = {
        enabled = true,
        left = { "mark", "sign" }, -- priority of signs on the left (high to low)
        right = { "fold", "git" }, -- priority of signs on the right (high to low)
        folds = {
          open = false, -- show open fold icons
          git_hl = false, -- use Git Signs hl for fold icons
        },
        git = {
          patterns = { "GitSign", "MiniDiffSign" }, -- patterns to match Git signs
        },
        refresh = 50, -- refresh at most every 50ms
      },
      words = { enabled = true }, -- 高亮光标单词, 显示计数
    },
    keys = {
      -- Top Pickers & Explorer
      {
        "<leader><space>",
        function()
          Snacks.picker.smart()
        end,
        desc = "Smart Find Files",
      },
      {
        "<leader>,",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Buffers",
      },
      {
        "<leader>/",
        function()
          Snacks.picker.grep()
        end,
        desc = "Grep",
      },
      {
        "<leader>:",
        function()
          Snacks.picker.command_history()
        end,
        desc = "Command History",
      },
      {
        "<leader>n",
        function()
          Snacks.picker.notifications()
        end,
        desc = "Notification History",
      },
      {
        "<leader>e",
        function()
          Snacks.picker.explorer()
        end,
        desc = "File Explorer",
      },
      -- find
      {
        "<leader>fb",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Buffers",
      },
      {
        "<leader>fc",
        function()
          Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
        end,
        desc = "Find Config File",
      },
      {
        "<leader>ff",
        function()
          Snacks.picker.files()
        end,
        desc = "Find Files",
      },
      {
        "<leader>fg",
        function()
          Snacks.picker.git_files()
        end,
        desc = "Find Git Files",
      },
      {
        "<leader>fp",
        function()
          Snacks.picker.projects()
        end,
        desc = "Projects",
      },
      {
        "<leader>fr",
        function()
          Snacks.picker.recent()
        end,
        desc = "Recent",
      },
      -- Other
      {
        "<leader>z",
        function()
          Snacks.zen()
        end,
        desc = "Toggle Zen Mode",
      },
      {
        "<leader>Z",
        function()
          Snacks.zen.zoom()
        end,
        desc = "Toggle Zoom",
      },
      {
        "<leader>.",
        function()
          Snacks.scratch()
        end,
        desc = "Toggle Scratch Buffer",
      },
      {
        "<leader>S",
        function()
          Snacks.scratch.select()
        end,
        desc = "Select Scratch Buffer",
      },
      {
        "<leader>n",
        function()
          Snacks.notifier.show_history()
        end,
        desc = "Notification History",
      },
      {
        "<leader>bd",
        function()
          Snacks.bufdelete()
        end,
        desc = "Delete Buffer",
      },
      {
        "<leader>cR",
        function()
          Snacks.rename.rename_file()
        end,
        desc = "Rename File",
      },
      {
        "<leader>gB",
        function()
          Snacks.gitbrowse()
        end,
        desc = "Git Browse",
        mode = { "n", "v" },
      },
      {
        "<leader>gg",
        function()
          Snacks.lazygit()
        end,
        desc = "Lazygit",
      },
      {
        "<leader>un",
        function()
          Snacks.notifier.hide()
        end,
        desc = "Dismiss All Notifications",
      },
      {
        "<c-/>",
        function()
          Snacks.terminal()
        end,
        desc = "Toggle Terminal",
      },
      {
        "<c-_>",
        function()
          Snacks.terminal()
        end,
        desc = "which_key_ignore",
      },
      {
        "]]",
        function()
          Snacks.words.jump(vim.v.count1)
        end,
        desc = "Next Reference",
        mode = { "n", "t" },
      },
      {
        "[[",
        function()
          Snacks.words.jump(-vim.v.count1)
        end,
        desc = "Prev Reference",
        mode = { "n", "t" },
      },
      {
        "<leader>N",
        desc = "Neovim News",
        function()
          Snacks.win({
            file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
            width = 0.6,
            height = 0.6,
            wo = {
              spell = false,
              wrap = false,
              signcolumn = "yes",
              statuscolumn = " ",
              conceallevel = 3,
            },
          })
        end,
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end

          -- Override print to use snacks for `:=` command
          if vim.fn.has("nvim-0.11") == 1 then
            vim._print = function(_, ...)
              dd(...)
            end
          else
            vim.print = _G.dd
          end

          -- Create some toggle mappings
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle
            .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
            :map("<leader>uc")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          Snacks.toggle.indent():map("<leader>ug")
          Snacks.toggle.dim():map("<leader>uD")
        end,
      })
    end,
  },
}
