# 继承现有环境变量
set -g update-environment 'DISPLAY SSH_ASKPASS SSH_AUTH_SOCK SSH_AGENT_PID'

# 可以使用鼠标滚动
set -g mouse on

# 启用 OSC 52 剪贴板
set -g set-clipboard on
set -g allow-passthrough on

# 设置鼠标滚轮每次只滚动 1 行
bind-key -T copy-mode-vi WheelUpPane send-keys -X -N 1 scroll-up
bind-key -T copy-mode-vi WheelDownPane send-keys -X -N 1 scroll-down
bind-key -T copy-mode WheelUpPane send-keys -X -N 1 scroll-up
bind-key -T copy-mode WheelDownPane send-keys -X -N 1 scroll-down

# 复制模式设置
setw -g mode-keys vi

# 鼠标拖动选择后自动复制，但不退出复制模式
unbind -T copy-mode-vi MouseDragEnd1Pane
bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-selection

# 键盘选择后复制不退出复制模式
bind -T copy-mode-vi Enter send-keys -X copy-selection
bind -T copy-mode-vi y send-keys -X copy-selection

# 将 Ctrl-o 改为 o
bind ^o send-keys o

# 设置 trigger + r 重新加载配置
bind r source-file ~/.tmux.conf \; display "tumx config reloaded :)"

# 设置分割快捷键
bind \\ split-window -h -c "#{pane_current_path}" # \ 为转移字符，要写两次
bind - split-window -v -c "#{pane_current_path}"

# 关闭会话快捷键
bind X confirm-before kill-session

# 没有延迟
set -s escape-time 1

# 这里要修改(alacritty 终端)，否则 neovim 中显示的颜色和打开tmux之后不一样
# 用 tmux-256color
set -g default-terminal "tmux-256color"

# 告诉 tmux：无论 default-term 是什么，都支持 Tc
set -ga terminal-overrides ",*:Tc"

# plug manager
set -g @plugin 'tmux-plugins/tpm'

# better morden terminal support
set -g @plugin 'tmux-plugins/tmux-sensible'

#+--- Color Themes ---+
set -g @plugin "arcticicestudio/nord-tmux"

#+--- Ctrl-S/R keymap to save session ---+
set -g @plugin "tmux-plugins/tmux-resurrect"

# 恢复 vim/nvim 会话
set -g @resurrect-strategy-vim 'session'
set -g @resurrect-strategy-nvim 'session'

# 恢复更多程序
set -g @resurrect-processes 'ssh psql mysql sqlite3 "~python" "~python3" "~uvicorn" "~node" "~npm" "~pnpm"'

# 保存后自动清理旧快照
set -g @resurrect-hook-post-save-all 'bash ~/.local/bin/tmux-cleanup-snapshots.sh'

#+--- auto save session ---+
set -g @plugin "tmux-plugins/tmux-continuum"
set -g @continuum-restore 'off' # auto restore off
set -g @continuum-save-interval '15' # auto save gap time (minute)

# 禁用额外的状态栏（只保留主状态栏）
set -g status-format[1] ''

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'
