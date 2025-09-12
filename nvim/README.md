# Neovim 现代配置说明文档

本文档详细说明了从 init.vim + vim-plug 迁移到 init.lua + lazy.nvim 的现代 Neovim 配置。

## 目录结构

```
~/.config/nvim/
├── init.lua                 # 主配置文件，负责引导和插件管理器初始化
└── lua/
    ├── config/
    │   ├── options.lua      # 基础编辑器设置
    │   └── keymaps.lua      # 快捷键映射
    └── plugins/
        └── init.lua         # 插件配置和设置
```

## 安装步骤

### 1. 备份现有配置

```bash
# 备份原配置
mv ~/.config/nvim ~/.config/nvim.backup

# 创建新配置目录
mkdir -p ~/.config/nvim/lua/config
mkdir -p ~/.config/nvim/lua/plugins
```

### 2. 创建配置文件

将对应的配置内容复制到相应文件中（见下方详细配置）。

### 3. 首次启动

```bash
nvim
```

启动时 lazy.nvim 会自动安装所有插件。

### 4. 安装 LSP 服务器

启动后运行：
```vim
:Mason
```

## 配置文件详解

### init.lua - 主配置入口

负责：
- 自动安装 lazy.nvim 插件管理器
- 引入基础配置模块
- 初始化插件系统

### lua/config/options.lua - 编辑器基础设置

#### 核心设置

| 配置项 | 值 | 说明 |
|-------|---|------|
| `number` | `true` | 显示行号 |
| `relativenumber` | `true` | 显示相对行号 |
| `cursorline` | `true` | 高亮当前行 |
| `signcolumn` | `"yes"` | 始终显示符号列 |
| `scrolloff` | `8` | 滚动时保持8行边距 |

#### 搜索设置

| 配置项 | 值 | 说明 |
|-------|---|------|
| `ignorecase` | `false` | 搜索区分大小写 |
| `smartcase` | `false` | 不使用智能大小写 |
| `inccommand` | `"split"` | 实时预览替换结果 |

#### 缩进设置

| 配置项 | 值 | 说明 |
|-------|---|------|
| `expandtab` | `true` | 将制表符转换为空格 |
| `tabstop` | `4` | 制表符宽度为4 |
| `shiftwidth` | `4` | 自动缩进宽度为4 |
| `softtabstop` | `4` | 软制表符宽度为4 |
| `autoindent` | `true` | 自动缩进 |
| `smartindent` | `false` | 禁用智能缩进 |
| `cindent` | `false` | 禁用C语言缩进 |

#### 文件和备份设置

| 配置项 | 值 | 说明 |
|-------|---|------|
| `backup` | `false` | 不创建备份文件 |
| `writebackup` | `false` | 写入时不备份 |
| `swapfile` | `false` | 不创建交换文件 |
| `undofile` | `true` | 启用持久化撤销 |

### lua/config/keymaps.lua - 快捷键映射

#### 基础快捷键

| 快捷键 | 模式 | 功能 |
|-------|------|------|
| `<Space>` | - | Leader 键 |
| `S` | Normal | 保存文件 (`:w`) |
| `Q` | Normal | 退出 (`:q`) |
| `<Leader>rc` | Normal | 打开 init.lua |
| `Y` | Normal | 复制全文到系统剪贴板 |

#### 导航快捷键

| 快捷键 | 模式 | 功能 |
|-------|------|------|
| `K` | Normal | 向上移动5行 |
| `J` | Normal | 向下移动5行 |
| `H` | Normal | 移动到行首 |
| `L` | Normal | 移动到行尾 |
| `W` | Normal | 向前移动5个单词 |
| `B` | Normal | 向后移动5个单词 |

#### 窗口管理

| 快捷键 | 模式 | 功能 |
|-------|------|------|
| `mw/mk/mj/mh/ml` | Normal | 窗口间移动 |
| `<Leader>k/j/h/l` | Normal | 分割窗口 |
| `<Leader>s` | Normal | 水平排列窗口 |
| `<Leader>v` | Normal | 垂直排列窗口 |
| `<Leader>q` | Normal | 关闭下方窗口 |

#### 标签页管理

| 快捷键 | 模式 | 功能 |
|-------|------|------|
| `tn` | Normal | 新建标签页 |
| `th/tl` | Normal | 切换标签页 |
| `tmh/tml` | Normal | 移动标签页 |

#### Insert 模式快捷键

| 快捷键 | 功能 |
|-------|------|
| `<C-f>` | 移动到行尾 |
| `<C-l>` | 向右移动一个字符 |
| `<C-b>` | 移动到行首 |

#### 终端模式快捷键

| 快捷键 | 功能 |
|-------|------|
| `<C-N>` | 退出终端模式 |
| `<C-O>` | 临时退出终端模式 |
| `<Leader>/` | 打开水平分割终端 |

## 插件配置详解

### 主题和外观

#### gbprod/nord.nvim
- **功能**：Nord 主题
- **配置**：启用透明背景
- **快捷键**：无

#### nvim-lualine/lualine.nvim
- **功能**：现代状态栏
- **替代**：eleline.vim
- **配置**：使用 nord 主题，简洁分隔符

#### romgrk/barbar.nvim
- **功能**：现代标签栏
- **替代**：vim-xtabline
- **配置**：动画效果，可点击

#### HiPhish/rainbow-delimiters.nvim
- **功能**：彩虹括号
- **替代**：luochen1990/rainbow
- **配置**：自动设置

### 文件导航和搜索

#### nvim-telescope/telescope.nvim
- **功能**：模糊搜索和文件导航
- **替代**：junegunn/fzf.vim
- **快捷键**：
  - `<C-p>`: 查找文件
  - `<C-f>`: 全文搜索
  - `<C-b>`: 查找缓冲区
  - `<C-h>`: 最近文件
  - `<Leader>;`: 命令历史

#### nvim-neo-tree/neo-tree.nvim
- **功能**：文件浏览器
- **替代**：coc-explorer
- **快捷键**：
  - `tt`: 切换文件浏览器

### LSP 和补全系统

#### neovim/nvim-lspconfig + hrsh7th/nvim-cmp
- **功能**：LSP 客户端和补全引擎
- **替代**：neoclide/coc.nvim
- **包含服务器**：
  - lua_ls (Lua)
  - tsserver (TypeScript/JavaScript)
  - pyright (Python)
  - html, cssls (Web)
  - jsonls, yamlls (配置文件)
  - omnisharp (C#)

- **快捷键**：
  - `gd`: 跳转到定义
  - `gr`: 查找引用
  - `gy`: 跳转到类型定义
  - `<Leader>rn`: 重命名
  - `K`: 显示悬浮文档
  - `<Tab>`: 选择下一个补全项
  - `<S-Tab>`: 选择上一个补全项
  - `<CR>`: 确认补全

#### williamboman/mason.nvim
- **功能**：LSP 服务器管理器
- **用法**：`:Mason` 管理 LSP 服务器

### 编辑增强

#### windwp/nvim-autopairs
- **功能**：自动配对括号
- **替代**：jiangmiao/auto-pairs
- **配置**：默认设置

#### mg979/vim-visual-multi
- **功能**：多光标编辑
- **快捷键**：
  - `<C-n>`: 选择下一个相同单词

#### numToStr/Comment.nvim
- **功能**：注释工具
- **替代**：tomtom/tcomment_vim
- **快捷键**：
  - `gcc`: 注释/取消注释当前行
  - `gbc`: 块注释
  - `gc` + motion: 注释选中内容

#### kylechui/nvim-surround
- **功能**：环绕操作
- **替代**：tpope/vim-surround
- **用法**：
  - `ys{motion}{char}`: 添加环绕
  - `ds{char}`: 删除环绕
  - `cs{old}{new}`: 更改环绕

### 代码片段

#### L3MON4D3/LuaSnip
- **功能**：代码片段引擎
- **替代**：SirVer/ultisnips
- **快捷键**：
  - `<C-j>`: 展开/跳转到下一个片段位置
  - `<C-k>`: 跳转到上一个片段位置

#### rafamadriz/friendly-snippets
- **功能**：预定义代码片段库
- **支持语言**：大多数主流编程语言

### 语法高亮

#### nvim-treesitter/nvim-treesitter
- **功能**：现代语法高亮和代码解析
- **支持语言**：
  - Web: html, css, javascript, typescript
  - 系统: c, cpp, rust, go
  - 脚本: python, lua, bash
  - 配置: json, yaml, vim
  - 文档: markdown

### 视觉增强

#### norcalli/nvim-colorizer.lua
- **功能**：颜色代码预览
- **替代**：RRethy/vim-hexokinase
- **支持格式**：hex, rgb, hsl 等

#### RRethy/vim-illuminate
- **功能**：高亮相同单词
- **配置**：自动高亮光标下的单词

#### lewis6991/gitsigns.nvim
- **功能**：Git 状态显示
- **功能**：在符号列显示 git 变更状态

### 语言特定支持

#### Vimjas/vim-python-pep8-indent
- **功能**：Python PEP8 缩进
- **触发**：仅在 Python 文件中加载

#### kevinoid/vim-jsonc
- **功能**：JSON with Comments 支持
- **触发**：仅在 JSON 文件中加载

### 终端和其他

#### wincent/terminus
- **功能**：终端集成增强
- **配置**：禁用鼠标支持

## 迁移对比表

| 功能类别 | 原插件 (vim-plug) | 新插件 (lazy.nvim) | 优势 |
|---------|------------------|-------------------|------|
| 补全系统 | coc.nvim | nvim-lspconfig + nvim-cmp | 原生LSP，更好性能 |
| 文件搜索 | fzf.vim | telescope.nvim | 更丰富的预览和过滤 |
| 状态栏 | eleline.vim | lualine.nvim | 更现代，高度可定制 |
| 标签栏 | vim-xtabline | barbar.nvim | 更好的视觉效果 |
| 文件浏览 | coc-explorer | neo-tree.nvim | 更现代的UI |
| 自动配对 | auto-pairs | nvim-autopairs | Lua实现，更好集成 |
| 注释 | tcomment_vim | Comment.nvim | 更智能的注释检测 |
| 环绕操作 | vim-surround | nvim-surround | 更好的可配置性 |
| 代码片段 | ultisnips | LuaSnip | 更好的LSP集成 |
| 语法高亮 | 内置语法 | treesitter | 更准确的语法解析 |
| 颜色显示 | vim-hexokinase | nvim-colorizer | 更轻量，无需编译 |

## 性能优化

### 懒加载策略
- 大部分插件按需加载
- 语言特定插件仅在相应文件类型时加载
- Treesitter 按需下载语言解析器

### 启动优化
- 使用 lazy.nvim 的懒加载机制
- 减少启动时加载的插件数量
- 优化的配置结构

## 维护和更新

### 插件管理
```vim
:Lazy                 " 打开插件管理器
:Lazy sync            " 同步插件（安装/更新/删除）
:Lazy update          " 更新所有插件
:Lazy clean           " 清理未使用的插件
```

### LSP 服务器管理
```vim
:Mason                " 打开 LSP 服务器管理器
:MasonUpdate          " 更新服务器
```

### Treesitter 管理
```vim
:TSInstall <language> " 安装语言解析器
:TSUpdate             " 更新所有解析器
```

## 故障排除

### 常见问题

1. **插件无法加载**
   - 检查网络连接
   - 运行 `:Lazy sync`

2. **LSP 不工作**
   - 运行 `:Mason` 确保服务器已安装
   - 检查 `:LspInfo`

3. **补全不工作**
   - 确保对应语言的 LSP 服务器已安装
   - 检查 `:CmpStatus`

4. **快捷键冲突**
   - 检查 `:verbose map <key>` 查看键映射

### 日志和调试

```vim
:Lazy log             " 查看插件日志
:LspLog               " 查看 LSP 日志
:checkhealth          " 检查 Neovim 健康状态
```

## 自定义建议

### 添加新插件
在 `lua/plugins/init.lua` 中添加新的插件配置：

```lua
{
  "author/plugin-name",
  config = function()
    -- 插件配置
  end,
}
```

### 修改快捷键
在 `lua/config/keymaps.lua` 中添加或修改：

```lua
keymap("n", "<your-key>", "<your-command>", opts)
```

### 调整编辑器设置
在 `lua/config/options.lua` 中修改：

```lua
opt.your_option = your_value
```

这个配置提供了一个现代、高效且功能完整的 Neovim 环境，完全替代了原有的 vim-plug + coc.nvim 配置，同时保持了所有熟悉的快捷键和工作流程。
