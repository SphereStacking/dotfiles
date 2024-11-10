#!/bin/bash

#----------------------------
# Oh My Zshのインストール
#----------------------------
install_oh_my_zsh(){
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh My Zshをインストールしています..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi
}
