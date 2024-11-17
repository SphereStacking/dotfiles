#!/bin/bash
setup_wsl2(){
    sudo apt update

    # starship
    curl -sS https://starship.rs/install.sh | sh

    # zsh git fzf bat htop fd-find ripgrep
    sudo apt install zsh git fzf bat htop fd-find ripgrep

    # rust
    curl https://sh.rustup.rs -sSf | sh

    # sheldonのインストール
    cargo install sheldon
    cargo install eza

    # zshをデフォルトシェルに設定
    chsh -s $(which zsh)
}
