#!/bin/bash
#----------------------------
# Homebrewのインストールと設定
#----------------------------
install_homebrew() {
  if ! command -v brew &>/dev/null; then
    echo "Homebrewが見つかりません。インストールを開始します..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    SHELL_PROFILE="$HOME/.bash_profile"
    [ -n "$ZSH_VERSION" ] && SHELL_PROFILE="$HOME/.zprofile"

    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$SHELL_PROFILE"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  echo "Homebrewをアップデートしています..."
  brew update
}

#----------------------------
# Brewfileによるパッケージのインストール
#----------------------------
install_brewfile(){

  BREWFILE_PATH="$DOTFILES_DIR/Brewfile"

  if [ ! -f "$BREWFILE_PATH" ]; then
    echo "Brewfileが見つかりません。$BREWFILE_PATH を確認してください。"
    exit 1
  fi

  echo "パッケージとアプリケーションをインストールしています..."
  brew bundle --file="$BREWFILE_PATH"
}

