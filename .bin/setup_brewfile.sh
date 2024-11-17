#!/bin/bash

#----------------------------
# Brewfileによるパッケージのインストール
#----------------------------
setup_brewfile(){

  BREWFILE_PATH="$DOTFILES_DIR/Brewfile"

  if [ ! -f "$BREWFILE_PATH" ]; then
    echo "Brewfileが見つかりません。$BREWFILE_PATH を確認してください。"
    exit 1
  fi

  echo "パッケージとアプリケーションをインストールしています..."
  brew bundle --file="$BREWFILE_PATH"
}
