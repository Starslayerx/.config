### 配置方法

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
