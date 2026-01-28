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

    # 基于 pane 行（而不是 state 行）来查找 session
    for snapshot in "$RESURRECT_DIR"/tmux_resurrect_*.txt; do
        [ -f "$snapshot" ] || continue
        local date_str=$(basename "$snapshot" | sed 's/tmux_resurrect_//' | sed 's/.txt//')
        grep "^pane" "$snapshot" 2>/dev/null | awk -F'\t' -v d="$date_str" '{print $2, d}'
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

    # 检查快照中是否有该 session（优先 pane，其次 window）
    local has_panes=false
    local has_windows=false

    if grep -q "^pane[[:space:]]$target_session[[:space:]]" "$snapshot_file"; then
        has_panes=true
    fi

    if grep -q "^window[[:space:]]$target_session[[:space:]]" "$snapshot_file"; then
        has_windows=true
    fi

    if [ "$has_panes" = false ] && [ "$has_windows" = false ]; then
        echo "错误：快照中不包含 session '$target_session'"
        return 1
    fi

    if [ "$has_panes" = false ]; then
        echo "注意：快照中只有窗口结构，没有进程信息"
    fi

    # 需要恢复进程的程序列表
    local restore_progs="vim nvim ssh psql mysql sqlite3 python python3 uvicorn node npm pnpm redis-server uv"

    local session_created=false
    local temp_panes=$(mktemp)
    local temp_windows=$(mktemp)
    local temp_cmds=$(mktemp)

    # 提取该 session 的所有 pane 和 window 信息
    grep "^pane[[:space:]]$target_session[[:space:]]" "$snapshot_file" > "$temp_panes"
    grep "^window[[:space:]]$target_session[[:space:]]" "$snapshot_file" > "$temp_windows"

    # 如果没有 pane 行，从 window 行提取窗口索引
    if [ ! -s "$temp_panes" ]; then
        # 只有窗口结构，没有 pane 数据，从 window 行创建
        local window_indices=$(awk -F'\t' '{print $3}' "$temp_windows" | sort -nu)

        for win_idx in $window_indices; do
            # 获取该 window 的名称
            local window_name=$(awk -F'\t' -v idx="$win_idx" '$3 == idx {gsub(/^:/, "", $4); print $4; exit}' "$temp_windows")
            [ -z "$window_name" ] && window_name="window-$win_idx"

            if [ "$session_created" = false ]; then
                # 创建 session 和第一个窗口
                tmux new-session -d -s "$target_session" -n "$window_name" 2>/dev/null
                session_created=true
            else
                # 创建后续窗口
                tmux new-window -t "$target_session:$win_idx" -n "$window_name"
            fi

            # 恢复窗口布局（如果有）
            local window_layout=$(awk -F'\t' -v idx="$win_idx" '$3 == idx {print $7; exit}' "$temp_windows")
            if [ -n "$window_layout" ]; then
                tmux select-layout -t "$target_session:$win_idx" "$window_layout" 2>/dev/null || true
            fi
        done

        rm -f "$temp_panes" "$temp_windows" "$temp_cmds"

        # 选择第一个 window
        tmux select-window -t "$target_session:0" 2>/dev/null || true

        if tmux has-session -t "$target_session" 2>/dev/null; then
            echo "成功恢复 session '$target_session'（仅窗口结构）"
            return 0
        else
            echo "错误：Session 创建失败"
            return 1
        fi
    fi

    # 正常流程：有 pane 数据
    # 获取所有唯一的 window index（按数字排序）
    local window_indices=$(awk -F'\t' '{print $3}' "$temp_panes" | sort -nu)

    # 第一阶段：创建所有 window 和 pane
    for win_idx in $window_indices; do
        # 获取该 window 的名称
        local window_name=$(awk -F'\t' -v idx="$win_idx" '$3 == idx {gsub(/^:/, "", $4); print $4; exit}' "$temp_windows")
        [ -z "$window_name" ] && window_name="window-$win_idx"

        # 获取该 window 的所有 pane，按 pane_idx 排序
        local temp_win_panes=$(mktemp)
        awk -F'\t' -v idx="$win_idx" '$3 == idx' "$temp_panes" | sort -t$'\t' -k6,6n > "$temp_win_panes"

        local pane_count=$(wc -l < "$temp_win_panes" | tr -d ' ')
        local created_first=false

        # 按顺序创建每个 pane
        while IFS=$'\t' read -r type session_name w_idx w2 flags pane_idx title pane_dir_raw rest; do
            local pane_dir="${pane_dir_raw#:}"

            if [ "$session_created" = false ]; then
                # 创建 session 和第一个 pane
                tmux new-session -d -s "$target_session" -n "$window_name" -c "$pane_dir" 2>/dev/null
                session_created=true
                created_first=true
            elif [ "$created_first" = false ]; then
                # 这个 window 的第一个 pane
                tmux new-window -t "$target_session:$win_idx" -n "$window_name" -c "$pane_dir"
                created_first=true
            else
                # 后续 pane - 使用 window index 定位
                tmux split-window -t "$target_session:$win_idx" -c "$pane_dir"
                tmux select-layout -t "$target_session:$win_idx" tiled >/dev/null 2>&1
            fi
        done < "$temp_win_panes"

        # 恢复该 window 的布局
        local window_layout=$(awk -F'\t' -v idx="$win_idx" '$3 == idx {print $7; exit}' "$temp_windows")
        if [ -n "$window_layout" ]; then
            tmux select-layout -t "$target_session:$win_idx" "$window_layout" 2>/dev/null || true
        fi

        # 保存每个 pane 的命令到临时文件（按 pane_idx 排序）
        # 使用 window index 而不是 window name 避免特殊字符问题
        awk -F'\t' -v idx="$win_idx" -v sess="$target_session" \
            '$3 == idx {
                pane_idx = $6
                cmd_name = $10
                full_cmd = $11
                gsub(/^:/, "", full_cmd)
                print pane_idx "\t" sess ":" idx "." pane_idx "\t" cmd_name "\t" full_cmd
            }' "$temp_panes" | sort -t$'\t' -k1,1n >> "$temp_cmds"

        rm -f "$temp_win_panes"
    done

    # 第二阶段：按顺序恢复进程，添加延迟确保依赖服务启动
    while IFS=$'\t' read -r pane_idx pane_target pane_cmd full_cmd; do
        [ -z "$pane_target" ] && continue
        [ -z "$full_cmd" ] && continue

        # 检查是否需要恢复该进程
        local should_restore=false
        for prog in $restore_progs; do
            if [ "$pane_cmd" = "$prog" ]; then
                should_restore=true
                break
            fi
        done

        if [ "$should_restore" = true ]; then
            echo "  启动 pane $pane_idx: $pane_cmd"
            tmux send-keys -t "$pane_target" "$full_cmd" C-m 2>/dev/null || {
                echo "  警告：启动 pane $pane_idx 失败，跳过"
            }
            # 添加短暂延迟，让服务有时间启动
            sleep 0.5
        fi
    done < "$temp_cmds"

    rm -f "$temp_panes" "$temp_windows" "$temp_cmds"

    # 选择第一个 window
    tmux select-window -t "$target_session:0" 2>/dev/null || true

    # 检查 session 是否创建成功
    if tmux has-session -t "$target_session" 2>/dev/null; then
        echo "成功恢复 session '$target_session'"
        return 0
    else
        echo "错误：Session 创建失败"
        return 1
    fi
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

    # 第一轮：优先查找最新的包含完整 pane 数据的快照
    local found_snapshot=""
    local latest_time=0

    for snapshot in "$RESURRECT_DIR"/tmux_resurrect_*.txt; do
        if [ -f "$snapshot" ]; then
            # 只查找有 pane 行的快照（完整数据）
            if grep -q "^pane[[:space:]]$session_name[[:space:]]" "$snapshot"; then
                # 提取时间戳
                local timestamp=$(basename "$snapshot" | sed 's/tmux_resurrect_//' | sed 's/.txt//' | sed 's/T//')
                if [ "$timestamp" -gt "$latest_time" ]; then
                    latest_time="$timestamp"
                    found_snapshot="$snapshot"
                fi
            fi
        fi
    done

    # 如果找到了完整快照，直接返回
    if [ -n "$found_snapshot" ]; then
        echo "$found_snapshot"
        return 0
    fi

    # 第二轮（降级）：如果没有完整快照，查找只有 window 行的快照
    latest_time=0
    for snapshot in "$RESURRECT_DIR"/tmux_resurrect_*.txt; do
        if [ -f "$snapshot" ]; then
            # 只查找有 window 行的快照（窗口结构）
            if grep -q "^window[[:space:]]$session_name[[:space:]]" "$snapshot"; then
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
