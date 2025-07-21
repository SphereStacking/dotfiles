#!/bin/bash

# 共通ユーティリティの読み込み
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=../core/utils.sh
source "$SCRIPT_DIR/../core/utils.sh"

#----------------------------
# Homebrewのインストールと設定
#----------------------------
setup_homebrew() {
  install_if_missing "brew" '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && echo '\''eval "$(/opt/homebrew/bin/brew shellenv)"'\'' >> $HOME/.zprofile && echo '\''eval "$(/opt/homebrew/bin/brew shellenv)"'\'' >> $HOME/.bash_profile && eval "$(/opt/homebrew/bin/brew shellenv)"'

  info "Homebrewをアップデート中..."
  brew update
}


