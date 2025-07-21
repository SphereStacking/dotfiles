#!/bin/bash

# 共通ユーティリティの読み込み
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=../core/utils.sh
source "$SCRIPT_DIR/../core/utils.sh"

#----------------------------
# fzfのシェル拡張機能をインストール
#----------------------------
setup_fzf_extension(){
  local current_os
  current_os=$(detect_os)
  
  case "$current_os" in
    macos)
      if is_installed "brew" && [ -f "$(brew --prefix)/opt/fzf/install" ]; then
        info "fzfのシェル拡張機能をインストール中..."
        yes | "$(brew --prefix)/opt/fzf/install" --all --no-bash --no-fish
        success "fzfシェル拡張機能のインストールが完了しました"
      else
        warn "Homebrew経由のfzfが見つかりません。先にBrewfileをインストールしてください。"
      fi
      ;;
    wsl2|linux)
      # Linux/WSL2ではfzfは既にパッケージマネージャーでインストールされている想定
      if is_installed "fzf"; then
        info "fzfは既にインストールされています（Linux/WSL2）"
      else
        warn "fzfがインストールされていません。パッケージマネージャーでインストールしてください。"
      fi
      ;;
    *)
      warn "サポートされていないOS: $current_os"
      ;;
  esac
}
