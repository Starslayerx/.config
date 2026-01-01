#!/bin/bash
# 清理 tmux-resurrect 旧快照，每个 session 只保留最新的
# 用于 tmux-resurrect 的 post-save hook

RESURRECT_DIR="$HOME/.local/share/tmux/resurrect"

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
