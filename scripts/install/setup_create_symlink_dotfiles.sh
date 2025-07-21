#!/bin/bash

# 共通ユーティリティの読み込み
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=../core/utils.sh
source "$SCRIPT_DIR/../core/utils.sh"

#----------------------------
# dotfilesシンボリックリンクの作成
# 新しいリンク管理システムを使用
#----------------------------
setup_symlink_dotfiles() {
  info "dotfilesのシンボリックリンクを作成中..."
  
  # 新しいリンク管理スクリプトを使用
  local link_script="$SCRIPT_DIR/../core/link.sh"
  
  if [[ -f "$link_script" ]]; then
    "$link_script" create
  else
    error "リンク管理スクリプトが見つかりません: $link_script"
    return 1
  fi
}
