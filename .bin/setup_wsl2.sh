#!/bin/bash
setup_wsl2(){
    sudo apt update

    # starship
    curl -sS https://starship.rs/install.sh | sh

    # zsh git fzf bat htop
    sudo apt install zsh git fzf bat htop

    # sheldonのインストール
    curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh \
        | bash -s -- --repo rossmacarthur/sheldon --to /usr/bin

    # zshをデフォルトシェルに設定
    chsh -s $(which zsh)
}
