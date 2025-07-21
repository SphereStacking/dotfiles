#!/bin/bash

# 共通ユーティリティの読み込み
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=../core/utils.sh
source "$SCRIPT_DIR/../core/utils.sh"

setup_wsl2(){
    info "WSL2環境のセットアップを開始します..."
    
    # パッケージリストの更新
    sudo apt update

    # 基本パッケージのインストール
    info "基本パッケージをインストール中..."
    sudo apt install -y zsh git fzf bat htop fd-find ripgrep curl build-essential
    
    # 日本語ロケールのインストール
    info "日本語ロケールをインストール中..."
    sudo apt install -y language-pack-ja
    sudo locale-gen ja_JP.UTF-8
    sudo update-locale

    # Rust環境のセットアップ（Starship、Sheldon、ezaに必要）
    install_if_missing "rustc" "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && source \$HOME/.cargo/env"
    
    # cargoのパス設定
    # shellcheck source=/dev/null
    [[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

    # ツールのインストール
    install_if_missing "starship" "curl -sS https://starship.rs/install.sh | sh -s -- --yes"
    install_if_missing "sheldon" "cargo install sheldon"
    install_if_missing "eza" "cargo install eza"

    # zshをデフォルトシェルに設定
    if [[ "$SHELL" != *"zsh"* ]]; then
        info "zshをデフォルトシェルに設定中..."
        chsh -s "$(which zsh)"
        info "次回ログイン時にzshが使用されます"
    else
        info "zshは既にデフォルトシェルに設定されています"
    fi
    
    success "WSL2環境のセットアップが完了しました！"
}
