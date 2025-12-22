#!/bin/bash
# Tmux 智能启动脚本
# 用途：重启电脑后直接恢复之前保存的 session，而不是创建新 session

# 检查是否有运行中的 tmux session
if tmux list-sessions &>/dev/null; then
    # 有 session，直接 attach
    tmux attach
else
    # 没有 session，检查是否有保存的快照
    RESURRECT_DIR="$HOME/.local/share/tmux/resurrect"
    LAST_SAVE="$RESURRECT_DIR/last"

    if [ -L "$LAST_SAVE" ] || [ -f "$LAST_SAVE" ]; then
        # 有保存的快照，恢复它
        echo "正在恢复上次保存的 tmux session..."

        # 创建一个临时 session（需要在 tmux 环境中才能恢复）
        tmux new-session -d -s temp_restore_session

        # 在 tmux 环境中执行恢复脚本
        tmux run-shell "$HOME/.tmux/plugins/tmux-resurrect/scripts/restore.sh"

        # 等待恢复完成（给一点时间）
        sleep 1

        # 检查是否有其他 session 被恢复
        SESSION_COUNT=$(tmux list-sessions 2>/dev/null | wc -l)

        if [ "$SESSION_COUNT" -gt 1 ]; then
            # 有其他 session 被恢复，删除临时 session
            tmux kill-session -t temp_restore_session 2>/dev/null
        fi

        # attach 到第一个可用的 session
        tmux attach
    else
        # 没有保存的快照，创建新 session
        echo "没有找到保存的 session，创建新的..."
        tmux new-session
    fi
fi
