#!/bin/bash

# 共通ユーティリティの読み込み
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=../core/utils.sh
source "$SCRIPT_DIR/../core/utils.sh"

#----------------------------
# Brewfileによるパッケージのインストール
#----------------------------
setup_brewfile(){
  # DOTFILESディレクトリの取得
  local dotfiles_dir
  dotfiles_dir="$(cd "$SCRIPT_DIR/../.." && pwd)"
  local brewfile_path="$dotfiles_dir/Brewfile"

  if [ ! -f "$brewfile_path" ]; then
    error "Brewfileが見つかりません: $brewfile_path"
    return 1
  fi

  if ! is_installed "brew"; then
    error "Homebrewがインストールされていません。先にsetup_homebrewを実行してください。"
    return 1
  fi

  info "Brewfileからパッケージとアプリケーションをインストール中..."
  brew bundle --file="$brewfile_path"
  success "Brewfileのインストールが完了しました"
}
