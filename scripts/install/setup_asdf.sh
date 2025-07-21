#!/bin/bash

# 共通ユーティリティの読み込み
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=../core/utils.sh
source "$SCRIPT_DIR/../core/utils.sh"

#----------------------------
# asdfバージョンマネージャーのインストール
#----------------------------
setup_asdf(){
  if [ ! -d "$HOME/.asdf" ]; then
    info "asdfをインストール中..."
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
    
    # .zshrcには追加しない（shell/common/init.zshで管理）
    info "asdfがインストールされました"
  else
    info "asdfは既にインストールされています"
  fi

  # asdfのセットアップ
  if [ -f "$HOME/.asdf/asdf.sh" ]; then
    # shellcheck source=/dev/null
    source "$HOME/.asdf/asdf.sh"
    
    # Node.jsプラグインの追加（既に存在する場合はエラーを無視）
    asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git 2>/dev/null || true
    
    # 最新のNode.jsをインストール
    if ! asdf list nodejs | grep -q "latest"; then
      info "Node.js最新版をインストール中..."
      asdf install nodejs latest
      asdf global nodejs latest
    else
      info "Node.jsは既にインストールされています"
    fi
  else
    warn "asdfが正しくインストールされていません"
  fi
}
