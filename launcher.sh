#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LAUNCHER_DIR="$SCRIPT_DIR/.launcher"

while true; do
  selected=$(find "$LAUNCHER_DIR" -name "*.sh" -type f | \
    sed "s|$LAUNCHER_DIR/||" | \
    fzf --prompt=" Search: " \
        --height=100% \
        --reverse \
        --border=rounded \
        --border-label="  Launcher ──── [Enter:Run | Esc:Exit] " \
        --cycle \
        --pointer="▶" \
        --marker="✓" \
        --preview="bat --style=numbers --color=always $LAUNCHER_DIR/{}" \
        --preview-window="right:50%:border-rounded" \
        --preview-label=" Preview " \
        --color="bg+:#313244,bg:#1e1e2e,spinner:#bbffcc,hl:#f9e2af" \
        --color="fg:#cdd6f4,header:#6c7086,info:#bbffcc,pointer:#bbffcc" \
        --color="marker:#bbffcc,fg+:#ffffff,prompt:#6c7086,hl+:#bbffcc" \
        --color="border:#bbffcc,label:#bbffcc,preview-border:#45475a,preview-label:#6c7086")

  # Escで終了
  [[ -z "$selected" ]] && break

  # スクリプト実行
  clear
  echo "▶ Running: $selected"
  echo "────────────────────────────────────"
  "$LAUNCHER_DIR/$selected"
  echo ""
  echo "Press any key to continue..."
  read -n 1 -s
done
