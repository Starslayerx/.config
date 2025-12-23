#!/bin/bash
# Tmux 智能启动脚本
# 用途：
#   tm           - 智能启动/恢复/attach tmux
#   tm <name>    - 从历史快照中搜索并恢复指定 session

SESSION_NAME="$1"
RESURRECT_DIR="$HOME/.local/share/tmux/resurrect"
LAST_SAVE="$RESURRECT_DIR/last"

# 恢复保存的 session 函数
restore_sessions() {
    local snapshot_file="$1"

    if [ -z "$snapshot_file" ]; then
        snapshot_file="$LAST_SAVE"
    fi

    if [ -L "$snapshot_file" ] || [ -f "$snapshot_file" ]; then
        echo "正在从快照恢复 tmux session..."

        # 创建临时 session 用于执行恢复
        tmux new-session -d -s temp_restore_session 2>/dev/null

        # 临时替换 last 链接指向指定快照
        local original_last=""
        if [ -L "$LAST_SAVE" ]; then
            original_last=$(readlink "$LAST_SAVE")
        fi

        # 如果指定了特定快照，临时修改 last 链接
        if [ "$snapshot_file" != "$LAST_SAVE" ]; then
            rm -f "$LAST_SAVE"
            ln -s "$(basename "$snapshot_file")" "$LAST_SAVE"
        fi

        # 执行恢复
        tmux run-shell "$HOME/.tmux/plugins/tmux-resurrect/scripts/restore.sh"

        # 等待恢复完成
        sleep 1.5

        # 恢复原来的 last 链接
        if [ -n "$original_last" ] && [ "$snapshot_file" != "$LAST_SAVE" ]; then
            rm -f "$LAST_SAVE"
            ln -s "$original_last" "$LAST_SAVE"
        fi

        # 清理临时 session
        tmux kill-session -t temp_restore_session 2>/dev/null

        return 0
    else
        return 1
    fi
}

# 在历史快照中查找包含指定 session 的快照文件
find_session_in_snapshots() {
    local session_name="$1"

    # 搜索所有快照，找到最新的包含该 session 的文件
    local found_snapshot=""
    local latest_time=0

    for snapshot in "$RESURRECT_DIR"/tmux_resurrect_*.txt; do
        if [ -f "$snapshot" ]; then
            # 检查快照中是否包含该 session
            if grep -q "^state[[:space:]]\\+$session_name[[:space:]]*\$" "$snapshot"; then
                # 提取时间戳
                local timestamp=$(basename "$snapshot" | sed 's/tmux_resurrect_//' | sed 's/.txt//' | sed 's/T//')
                if [ "$timestamp" -gt "$latest_time" ]; then
                    latest_time="$timestamp"
                    found_snapshot="$snapshot"
                fi
            fi
        fi
    done

    echo "$found_snapshot"
}

# 检查 session 是否存在
session_exists() {
    tmux has-session -t "$1" 2>/dev/null
}

# 如果指定了 session 名称
if [ -n "$SESSION_NAME" ]; then
    # 检查该 session 是否已存在
    if session_exists "$SESSION_NAME"; then
        # session 存在，直接 attach
        tmux attach -t "$SESSION_NAME"
    else
        # session 不存在，从历史快照中搜索
        echo "Session '$SESSION_NAME' 不存在，正在历史快照中搜索..."

        found_snapshot=$(find_session_in_snapshots "$SESSION_NAME")

        if [ -n "$found_snapshot" ]; then
            snapshot_date=$(basename "$found_snapshot" | sed 's/tmux_resurrect_//' | sed 's/.txt//')
            echo "找到快照：$snapshot_date"

            # 恢复该快照
            if restore_sessions "$found_snapshot"; then
                sleep 0.5

                # 检查恢复后是否有指定 session
                if session_exists "$SESSION_NAME"; then
                    echo "成功恢复 session '$SESSION_NAME'"
                    tmux attach -t "$SESSION_NAME"
                else
                    echo "错误：快照恢复失败"
                    exit 1
                fi
            else
                echo "错误：无法恢复快照"
                exit 1
            fi
        else
            echo "错误：在所有历史快照中都没有找到 session '$SESSION_NAME'"
            echo ""
            echo "可用的 session："

            # 显示当前运行的 session
            if tmux list-sessions &>/dev/null; then
                echo "运行中："
                tmux list-sessions
            fi

            # 显示所有快照中的 session
            echo ""
            echo "历史快照中的 session："
            for snapshot in "$RESURRECT_DIR"/tmux_resurrect_*.txt; do
                if [ -f "$snapshot" ]; then
                    sessions=$(grep "^state" "$snapshot" | awk '{print $2}')
                    if [ -n "$sessions" ]; then
                        snapshot_date=$(basename "$snapshot" | sed 's/tmux_resurrect_//' | sed 's/.txt//')
                        echo "  [$snapshot_date] $sessions"
                    fi
                fi
            done | sort -r | head -20

            exit 1
        fi
    fi
else
    # 没有指定 session，使用原有的智能启动逻辑
    if tmux list-sessions &>/dev/null; then
        # 有运行中的 session，直接 attach
        tmux attach
    else
        # 没有运行中的 session，尝试恢复最新快照
        if restore_sessions; then
            tmux attach
        else
            # 没有保存的快照，创建新 session
            echo "没有找到保存的 session，创建新的..."
            tmux new-session
        fi
    fi
fi
