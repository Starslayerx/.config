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
以下命令需要进入命令模式后输入
- 创建并命名窗口：`new-windows -t <index> -n <name>`，这个对应命令 `Ctrl-b c` 创建的新窗口
- 切换 pane 位置：`swap-pane -s 0 -t 1`
