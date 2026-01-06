### 配置方法

tmux 配置文件是 `~/.tmux.conf`

使用智能恢复脚本，首先将其存储在 `~/.local/bin/tmux-smart-start.sh` 和 `~/.local/bin/tmux-cleanup-snapshots.sh`

然后在 `~/.zshrc` 或 `~/.bashrc` 添加下面 alias 

```bash
# Tmux 智能启动
alias tm='~/.local/bin/tmux-smart-start.sh'
```

### 使用方式
Tmux 智能启动脚本
```bash
tm              - 智能启动/恢复/attach tmux
tm <name>       - 从历史快照中搜索并恢复指定 session
tm --clean      - 清理旧快照，每个 session 只保留最新的
tm --list       - 列出所有可恢复的 session
```

### 常用命令
tmux 窗口切换方法

当使用 `Ctrl-b + c` 创建多个窗口后,有以下几种切换方式:

1. 基本切换命令

| 快捷键 | 功能 |
|--------|------|
| Ctrl-b + n | 切换到下一个窗口 (next) |
| Ctrl-b + p | 切换到上一个窗口 (previous) |
| Ctrl-b + 0-9 | 直接切换到指定编号的窗口 |
| Ctrl-b + w | 显示窗口列表,可用方向键选择 |
| Ctrl-b + l | 切换到上次使用的窗口 (last) |

2. 调整窗口顺序

改变窗口的排列顺序:

| 命令 | 功能 |
|------|------|
| Ctrl-b + . | 修改当前窗口的编号 (会提示输入新编号) |
| Ctrl-b + : 然后输入 swap-window -s 3 -t 1 | 交换窗口 3 和窗口 1 的位置 |
| Ctrl-b + : 然后输入 move-window -t 5 | 将当前窗口移动到编号 5 |

3. 实用技巧

查看所有窗口:

`Ctrl-b + w`

这会显示一个可视化的窗口列表,用方向键选择后按 Enter 切换。
重命名窗口 (方便识别):
`Ctrl-b + ,`
这样可以给每个窗口起个有意义的名字,而不是只看编号。

原理说明
- tmux 的窗口类似浏览器标签页,按创建顺序从 0 开始编号
- `Ctrl-b` 是 tmux 的前缀键,所有命令都需要先按这个组合
- 窗口编号可以不连续 (比如 0, 2, 5),删除窗口不会自动重新编号
