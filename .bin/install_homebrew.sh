#!/bin/bash
#----------------------------
# Homebrewのインストールと設定
#----------------------------
install_homebrew() {
  if ! command -v brew &>/dev/null; then
    echo "Homebrewが見つかりません。インストールを開始します..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.bash_profile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  echo "Homebrewをアップデートしています..."
  brew update
}


