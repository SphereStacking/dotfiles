#!/usr/bin/env bash
set -ue

# リポジトリのディレクトリを取得
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "dotfilesディレクトリ: $DOTFILES_DIR"

source "$DOTFILES_DIR/.bin/install_homebrew.sh"
source "$DOTFILES_DIR/.bin/install_oh_my_zsh.sh"
source "$DOTFILES_DIR/.bin/install_fzf_extension.sh"


helpmsg() {
  command echo "Usage: $0 [--help | -h]" 0>&2
  command echo "  --install-homebrew"
  command echo "  --install-oh-my-zsh"
  command echo "  --install-fzf-extension"
}

link_to_homedir() {
  command echo "backup old dotfiles..."
  if [ ! -d "$HOME/.dotbackup" ];then
    command echo "$HOME/.dotbackup not found. Auto Make it"
    command mkdir "$HOME/.dotbackup"
  fi

  local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
  local dotdir=$(dirname ${script_dir})
  if [[ "$HOME" != "$dotdir" ]];then
    for f in $dotdir/.??*; do
      [[ `basename $f` == ".git" ]] && continue
      if [[ -L "$HOME/`basename $f`" ]];then
        command rm -f "$HOME/`basename $f`"
      fi
      if [[ -e "$HOME/`basename $f`" ]];then
        command mv "$HOME/`basename $f`" "$HOME/.dotbackup"
      fi
      command ln -snf $f $HOME
    done
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
    --install-homebrew)
      install_homebrew
      ;;
    --install-oh-my-zsh)
      install_oh_my_zsh
      ;;
    --install-fzf-extension)
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

