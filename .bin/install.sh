#!/usr/bin/env bash
set -ue

# リポジトリのディレクトリを取得（.binの親ディレクトリを指すように修正）
DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
command echo "dotfilesディレクトリ: $DOTFILES_DIR"

source "$DOTFILES_DIR/.bin/install_homebrew.sh"
source "$DOTFILES_DIR/.bin/install_brewfile.sh"
source "$DOTFILES_DIR/.bin/install_oh_my_zsh.sh"
source "$DOTFILES_DIR/.bin/install_fzf_extension.sh"
source "$DOTFILES_DIR/.bin/install_asdf.sh"
source "$DOTFILES_DIR/.bin/script_create_symlink_dotfiles.sh"

helpmsg() {
  command echo "Usage: $0 [--help | -h]" 0>&2
  command echo "  --install-homebrew|-homebrew"
  command echo "  --install-oh-my-zsh|-ohmyzsh"
  command echo "  --install-fzf-extension|-fzf"
  command echo "  --install-asdf|-asdf"
  command echo "  --install-all|-all"
  command echo "  --create-symlink|-symlink"
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
    --install-brewfile|-brewfile)
      install_brewfile
      ;;
    --install-oh-my-zsh|-ohmyzsh)
      install_oh_my_zsh
      ;;
    --install-fzf-extension|-fzf)
      install_fzf_extension
      ;;
    --install-asdf|-asdf)
      install_asdf
      ;;
    --install-all|-all)
      install_homebrew
      install_brewfile
      install_asdf
      install_oh_my_zsh
      install_fzf_extension
      ;;
    --create-symlink|-symlink)
      create_symlink_dotfiles
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

