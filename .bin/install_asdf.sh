#!/bin/bash

#----------------------------
# Oh My Zshのインストール
#----------------------------
install_asdf(){
  if [ ! -d "$HOME/.asdf" ]; then
    echo "asdfをインストールしています..."
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf
    echo ". $HOME/.asdf/asdf.sh" >> ~/.zshrc
  fi
}
