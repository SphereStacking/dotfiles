#!/bin/bash
#----------------------------
# fzfのシェル拡張機能をインストール
#----------------------------
setup_fzf_extension(){
  if [ -f "$(brew --prefix)/opt/fzf/install" ]; then
    echo "fzfのシェル拡張機能をインストールしています..."
    yes | "$(brew --prefix)/opt/fzf/install" --all --no-bash --no-fish
  fi
}
