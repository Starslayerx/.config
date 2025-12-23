### 配置方法

tmux 配置文件是 `~/.tmux.conf`

使用智能恢复脚本，首先将其存储在 `~/.local/bin/tmux-smart-start.sh`

然后在 `~/.zshrc` 或 `~/.bashrc` 添加下面 alias 

```bash
# Tmux 智能启动
alias tm='~/.local/bin/tmux-smart-start.sh'
```

### 使用方式

- 恢复默认会话
   ```bash
   tm
   ```

- 恢复指定会话
   ```bash
   tm <session>
   ```
   这个适用于使用下面命令创建的会话
   ```bash
   tmux new -s <session>
   ```
   如果没有指定，则默认从 0 开始自增到 9


### 常用命令
以下命令需要进入命令模式后输入
- 创建并命名窗口：`new-windows -t <index> -n <name>`，这个对应命令 `Ctrl-b c` 创建的新窗口
- 切换 pane 位置：`swap-pane -s 0 -t 1`
