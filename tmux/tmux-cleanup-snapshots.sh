#!/bin/bash
# 清理 tmux-resurrect 旧快照，每个 session 只保留最新的
# 用于 tmux-resurrect 的 post-save hook

RESURRECT_DIR="$HOME/.local/share/tmux/resurrect"
LAST_SAVE="$RESURRECT_DIR/last"

# ============================================
# 第一步：验证最新快照的完整性
# ============================================
if [ -L "$LAST_SAVE" ]; then
    last_snapshot=$(readlink -f "$LAST_SAVE" 2>/dev/null)

    if [ -f "$last_snapshot" ]; then
        pane_count=$(grep -c "^pane" "$last_snapshot" 2>/dev/null || echo 0)

        # 如果快照没有 pane 行，说明不完整
        if [ "$pane_count" -eq 0 ]; then
            echo "[tmux-resurrect] 检测到不完整快照: $(basename "$last_snapshot")" >&2
            echo "[tmux-resurrect] Pane 数据缺失，删除并回退到上一个完整快照..." >&2

            # 删除不完整快照
            rm "$last_snapshot"

            # 找到最新的完整快照（有 pane 行的）
            latest_complete=$(find "$RESURRECT_DIR" -name "tmux_resurrect_*.txt" -type f -exec grep -l "^pane" {} \; 2>/dev/null | sort -r | head -1)

            if [ -n "$latest_complete" ]; then
                rm -f "$LAST_SAVE"
                ln -s "$(basename "$latest_complete")" "$LAST_SAVE"
                echo "[tmux-resurrect] 已回退到: $(basename "$latest_complete")" >&2
            else
                echo "[tmux-resurrect] 警告：没有找到完整的快照文件" >&2
            fi
        fi
    fi
fi

# ============================================
# 第二步：清理旧快照（每个 session 只保留最新的）
# ============================================
temp_file=$(mktemp)
keep_file=$(mktemp)

# 收集所有 session 及其最新快照
for snapshot in "$RESURRECT_DIR"/tmux_resurrect_*.txt; do
    [ -f "$snapshot" ] || continue
    basename_snap=$(basename "$snapshot")
    grep "^state" "$snapshot" 2>/dev/null | awk '{print $2}' | while read session; do
        echo "$session $basename_snap"
    done
done | sort -k1,1 -k2,2r | awk '!seen[$1]++' > "$temp_file"

# 提取需要保留的快照
awk '{print $2}' "$temp_file" | sort -u > "$keep_file"

# 删除不需要的快照
for snapshot in "$RESURRECT_DIR"/tmux_resurrect_*.txt; do
    [ -f "$snapshot" ] || continue
    basename_snap=$(basename "$snapshot")
    if ! grep -qx "$basename_snap" "$keep_file"; then
        rm "$snapshot"
    fi
done

rm -f "$temp_file" "$keep_file"
