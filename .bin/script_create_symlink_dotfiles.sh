#!/bin/bash

# 概要:
# このスクリプトは、指定されたディレクトリ内のドットファイルをホームディレクトリにシンボリックリンクとして配置します。
# 既存のファイルはバックアップディレクトリに移動されます。
#
# 使用方法:
# 1. スクリプトを実行可能にします: chmod +x script_create_symlink_dotfiles.sh
# 2. スクリプトを実行します: ./script_create_symlink_dotfiles.sh
#
# 注意:
# - バックアップは$HOME/.dotbackupに保存されます。

__private_backup_and_create_symlink() {
  local src=$1
  local dest=$2

  for item in "$src"/*; do
    local base_item=$(basename "$item")
    local dest_item="$dest/$base_item"

    if [[ -d "$item" ]]; then
      # ディレクトリの場合、再帰的に処理
      if [[ ! -d "$dest_item" ]]; then
        command mkdir -p "$dest_item"
      fi
      __private_backup_and_create_symlink "$item" "$dest_item"
    else
      # ファイルの場合、バックアップしてリンクを作成
      if [[ -L "$dest_item" ]]; then
        command rm -f "$dest_item"
      fi
      if [[ -e "$dest_item" ]]; then
        command mv "$dest_item" "$HOME/.dotbackup"
      fi
      command ln -snf "$item" "$dest_item"
    fi
  done
}

__link_dotfiles_to_homedir() {
  command echo "backup old dotfiles..."
  if [ ! -d "$HOME/.dotbackup" ]; then
    command echo "$HOME/.dotbackup not found. Auto Make it"
    command mkdir "$HOME/.dotbackup"
  fi

  # scriptのが実行されたdirを取得
  local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
  local dotdir=$(dirname ${script_dir})
  if [[ "$HOME" != "$dotdir" ]]; then
    __private_backup_and_create_symlink "$dotdir" "$HOME"
  else
    command echo "same install src dest"
  fi
}

create_symlink_dotfiles() {
  __link_dotfiles_to_homedir
}
