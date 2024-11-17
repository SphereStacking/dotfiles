#!/usr/bin/env bash
set -ue

# リポジトリのディレクトリを取得（.binの親ディレクトリを指すように修正）
DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
command echo "dotfilesディレクトリ: $DOTFILES_DIR"

source "$DOTFILES_DIR/.bin/setup_homebrew.sh"
source "$DOTFILES_DIR/.bin/setup_brewfile.sh"
source "$DOTFILES_DIR/.bin/setup_oh_my_zsh.sh"
source "$DOTFILES_DIR/.bin/setup_fzf_extension.sh"
source "$DOTFILES_DIR/.bin/setup_asdf.sh"
source "$DOTFILES_DIR/.bin/setup_create_symlink_dotfiles.sh"

helpmsg() {
  command echo "Usage: $0 [--help | -h]" 0>&2
  command echo "  --setup-homebrew"
  command echo "  --setup-oh-my-zsh"
  command echo "  --setup-fzf-extension"
  command echo "  --setup-asdf"
  command echo "  --setup-all"
  command echo "  --setup-symlink"
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
    --setup-homebrew|-homebrew)
      setup_homebrew
      ;;
    --setup-brewfile|-brewfile)
      setup_brewfile
      ;;
    --setup-oh-my-zsh|-ohmyzsh)
      setup_oh_my_zsh
      ;;
    --setup-fzf-extension|-fzf)
      setup_fzf_extension
      ;;
    --setup-asdf|-asdf)
      setup_asdf
      ;;
    --setup-symlink|-symlink)
      setup_symlink_dotfiles
      git config --global include.path "~/.gitconfig_shared"
      ;;
    *)
      command echo "Invalid option: $1"
      helpmsg
      exit 1
      ;;
  esac
  shift
done

command echo -e "Install completed!!!!"

