#!/bin/bash
# Tmux 智能启动脚本
# 用途：
#   tm              - 智能启动/恢复/attach tmux
#   tm <name>       - 从历史快照中搜索并恢复指定 session
#   tm --clean      - 清理旧快照，每个 session 只保留最新的
#   tm --list       - 列出所有可恢复的 session

RESURRECT_DIR="$HOME/.local/share/tmux/resurrect"
LAST_SAVE="$RESURRECT_DIR/last"

# 清理旧快照，每个 session 只保留最新的快照
cleanup_snapshots() {
    echo "正在清理旧快照..."

    local temp_file=$(mktemp)
    local keep_file=$(mktemp)

    # 收集所有 session 及其最新快照
    for snapshot in "$RESURRECT_DIR"/tmux_resurrect_*.txt; do
        [ -f "$snapshot" ] || continue
        local basename_snap=$(basename "$snapshot")
        grep "^state" "$snapshot" 2>/dev/null | awk '{print $2}' | while read session; do
            echo "$session $basename_snap"
        done
    done | sort -k1,1 -k2,2r | awk '!seen[$1]++' > "$temp_file"

    # 提取需要保留的快照
    awk '{print $2}' "$temp_file" | sort -u > "$keep_file"

    # 显示保留的快照
    while read session snapshot; do
        echo "  保留 $session -> $snapshot"
    done < "$temp_file"

    # 删除不需要的快照
    local deleted=0
    for snapshot in "$RESURRECT_DIR"/tmux_resurrect_*.txt; do
        [ -f "$snapshot" ] || continue
        local basename_snap=$(basename "$snapshot")
        if ! grep -qx "$basename_snap" "$keep_file"; then
            rm "$snapshot"
            ((deleted++))
        fi
    done

    rm -f "$temp_file" "$keep_file"
    echo "清理完成，删除了 $deleted 个旧快照"
}

# 列出所有可恢复的 session
list_sessions() {
    echo "=== 运行中的 session ==="
    if tmux list-sessions 2>/dev/null; then
        :
    else
        echo "  (无)"
    fi

    echo ""
    echo "=== 可恢复的 session ==="

    local temp_file=$(mktemp)

    for snapshot in "$RESURRECT_DIR"/tmux_resurrect_*.txt; do
        [ -f "$snapshot" ] || continue
        local date_str=$(basename "$snapshot" | sed 's/tmux_resurrect_//' | sed 's/.txt//')
        grep "^state" "$snapshot" 2>/dev/null | awk -v d="$date_str" '{print $2, d}'
    done | sort -k1,1 -k2,2r | awk '!seen[$1]++' > "$temp_file"

    if [ ! -s "$temp_file" ]; then
        echo "  (无)"
    else
        while read session date; do
            echo "  $session ($date)"
        done < "$temp_file" | sort
    fi

    rm -f "$temp_file"
}

# 处理命令行选项
case "$1" in
    --clean)
        cleanup_snapshots
        exit 0
        ;;
    --list)
        list_sessions
        exit 0
        ;;
esac

SESSION_NAME="$1"

# 从快照文件中手动恢复单个 session（不影响其他 session）
restore_single_session() {
    local snapshot_file="$1"
    local target_session="$2"

    if [ ! -f "$snapshot_file" ]; then
        return 1
    fi

    echo "正在从快照中恢复 session '$target_session'..."

    # 检查快照中是否有该 session
    if ! grep -q "^state.*$target_session" "$snapshot_file"; then
        echo "错误：快照中不包含 session '$target_session'"
        return 1
    fi

    # 创建临时快照文件，只包含目标 session，并去掉程序恢复信息
    local temp_snapshot="$RESURRECT_DIR/temp_restore_$target_session.txt"
    local temp_snapshot_with_activate="$RESURRECT_DIR/temp_restore_${target_session}_activated.txt"

    # 提取目标 session 的所有行
    grep "^pane[[:space:]]\\+$target_session[[:space:]]" "$snapshot_file" > "$temp_snapshot"
    grep "^window[[:space:]]\\+$target_session[[:space:]]" "$snapshot_file" >> "$temp_snapshot"
    echo "state	$target_session	" >> "$temp_snapshot"

    # 为每个 pane 添加虚拟环境激活命令
    > "$temp_snapshot_with_activate"

    # 不修改 command，直接复制原始内容
    grep "^pane[[:space:]]\\+$target_session[[:space:]]" "$snapshot_file" >> "$temp_snapshot_with_activate"

    # 添加 window 和 state 行
    grep "^window[[:space:]]\\+$target_session[[:space:]]" "$snapshot_file" >> "$temp_snapshot_with_activate"
    echo "state	$target_session	" >> "$temp_snapshot_with_activate"

    # 临时替换 last 链接
    local original_last=""
    if [ -L "$LAST_SAVE" ]; then
        original_last=$(readlink "$LAST_SAVE")
    fi

    # 备份并替换 last 链接
    rm -f "$LAST_SAVE"
    ln -s "$(basename "$temp_snapshot_with_activate")" "$LAST_SAVE"

    # 创建临时 session 用于执行恢复脚本
    tmux new-session -d -s temp_restore_session_$$ 2>/dev/null

    # 执行恢复
    tmux run-shell "$HOME/.tmux/plugins/tmux-resurrect/scripts/restore.sh"

    # 等待恢复完成
    sleep 2

    # 恢复原来的 last 链接
    rm -f "$LAST_SAVE"
    if [ -n "$original_last" ]; then
        ln -s "$original_last" "$LAST_SAVE"
    fi

    # 清理临时 session
    tmux kill-session -t temp_restore_session_$$ 2>/dev/null

    # 删除临时快照文件
    rm -f "$temp_snapshot"
    rm -f "$temp_snapshot_with_activate"

    echo "成功恢复 session '$target_session'"
    return 0
}

# 使用 tmux-resurrect 恢复所有 session（用于没有运行 session 时）
restore_all_sessions() {
    local snapshot_file="$1"

    if [ -z "$snapshot_file" ]; then
        snapshot_file="$LAST_SAVE"
    fi

    if [ -L "$snapshot_file" ] || [ -f "$snapshot_file" ]; then
        echo "正在从快照恢复所有 tmux session..."

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
            if grep -q "^state[[:space:]].*$session_name" "$snapshot"; then
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

            # 只恢复指定的 session
            if restore_single_session "$found_snapshot" "$SESSION_NAME"; then
                sleep 0.3
                if session_exists "$SESSION_NAME"; then
                    tmux attach -t "$SESSION_NAME"
                else
                    echo "错误：Session 创建失败"
                    exit 1
                fi
            else
                echo "错误：无法恢复 session"
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
                    sessions=$(grep "^state" "$snapshot" | awk '{for(i=2;i<=NF;i++) print $i}')
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
        # 有运行中的 session，选择一个 attach（不影响其他客户端）
        # 获取第一个可用的 session
        FIRST_SESSION=$(tmux list-sessions -F "#{session_name}" | head -1)
        tmux attach -t "$FIRST_SESSION"
    else
        # 没有运行中的 session，尝试恢复最新快照
        if restore_all_sessions; then
            # 恢复后，attach 到第一个可用 session
            FIRST_SESSION=$(tmux list-sessions -F "#{session_name}" | head -1)
            if [ -n "$FIRST_SESSION" ]; then
                tmux attach -t "$FIRST_SESSION"
            else
                tmux attach
            fi
        else
            # 没有保存的快照，创建新 session
            echo "没有找到保存的 session，创建新的..."
            tmux new-session
        fi
    fi
fi
