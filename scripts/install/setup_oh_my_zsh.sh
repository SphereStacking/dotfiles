#!/bin/bash

# 共通ユーティリティの読み込み
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=../core/utils.sh
source "$SCRIPT_DIR/../core/utils.sh"

#----------------------------
# Oh My Zshのインストール
#----------------------------
setup_oh_my_zsh(){
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    info "Oh My Zshをインストール中..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  else
    info "Oh My Zshは既にインストールされています"
  fi
}
