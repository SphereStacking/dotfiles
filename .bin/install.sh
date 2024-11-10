#!/usr/bin/env bash
set -ue

# リポジトリのディレクトリを取得
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "dotfilesディレクトリ: $DOTFILES_DIR"

source "$DOTFILES_DIR/install_homebrew.sh"
source "$DOTFILES_DIR/install_oh_my_zsh.sh"
source "$DOTFILES_DIR/install_fzf_extension.sh"


helpmsg() {
  command echo "Usage: $0 [--help | -h]" 0>&2
  command echo "  --install-homebrew"
  command echo "  --install-oh-my-zsh"
  command echo "  --install-fzf-extension"
}

backup_and_link() {
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
      backup_and_link "$item" "$dest_item"
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

link_to_homedir() {
  command echo "backup old dotfiles..."
  if [ ! -d "$HOME/.dotbackup" ]; then
    command echo "$HOME/.dotbackup not found. Auto Make it"
    command mkdir "$HOME/.dotbackup"
  fi

  local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
  local dotdir=$(dirname ${script_dir})
  if [[ "$HOME" != "$dotdir" ]]; then
    backup_and_link "$dotdir" "$HOME"
  else
    command echo "same install src dest"
  fi
}

while [ $# -gt 0 ];do
  case ${1} in
    --debug|-d)
      set -uex
      ;;
    --help|-h)
      helpmsg
      exit 1
      ;;
    --install-homebrew|-homebrew)
      install_homebrew
      ;;
    --install-oh-my-zsh|-ohmyzsh)
      install_oh_my_zsh
      ;;
    --install-fzf-extension|-fzf)
      install_fzf_extension
      ;;
    --install-all|-all)
      install_homebrew
      install_oh_my_zsh
      install_fzf_extension
      ;;
    *)
      ;;
  esac
  shift
done

link_to_homedir
git config --global include.path "~/.gitconfig_shared"
command echo -e "Install completed!!!!"

