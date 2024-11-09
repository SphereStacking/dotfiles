#!/bin/bash

# dotfilesインストールスクリプト

# リポジトリのディレクトリを取得
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "dotfilesディレクトリ: $DOTFILES_DIR"

#----------------------------
# シンボリックリンクの作成
#----------------------------

echo "シンボリックリンクを作成しています..."

# ホームディレクトリに配置するファイル
FILES=(
  ".gitconfig"
  ".zshrc"
  # 他の設定ファイルを追加
)

for file in "${FILES[@]}"; do
  TARGET="$HOME/$file"
  SOURCE="$DOTFILES_DIR/$file"

  if [ -f "$TARGET" ] && [ ! -L "$TARGET" ]; then
    mv "$TARGET" "$TARGET.backup"
    echo "既存の $file をバックアップしました。"
  fi

  ln -snf "$SOURCE" "$TARGET"
  echo "$file のシンボリックリンクを作成しました。"
done

# ~/.config ディレクトリ内の設定ファイル
CONFIG_FILES=(
  "starship.toml"
  # 他の設定ファイルがあれば追加
)

mkdir -p "$HOME/.config"

for file in "${CONFIG_FILES[@]}"; do
  TARGET="$HOME/.config/$file"
  SOURCE="$DOTFILES_DIR/.config/$file"

  if [ -f "$TARGET" ] && [ ! -L "$TARGET" ]; then
    mv "$TARGET" "$TARGET.backup"
    echo "既存の $file を $TARGET.backup にバックアップしました。"
  fi

  ln -snf "$SOURCE" "$TARGET"
  echo "$file のシンボリックリンクを作成しました。"
done

# scripts ディレクトリ内のスクリプトのシンボリックリンク
SCRIPTS_DIR="$HOME/dotfiles/scripts"
mkdir -p "$SCRIPTS_DIR"

SCRIPT_FILES=(
  "fzf-git.sh"
  # 他のスクリプトがあれば追加
)

for file in "${SCRIPT_FILES[@]}"; do
  TARGET="$SCRIPTS_DIR/$file"
  SOURCE="$DOTFILES_DIR/scripts/$file"

  if [ ! -e "$TARGET" ]; then
    ln -snf "$SOURCE" "$TARGET"
    echo "$file のシンボリックリンクを作成しました。"
  fi
done

#----------------------------
# Homebrewのインストールと設定
#----------------------------

if ! command -v brew &>/dev/null; then
  echo "Homebrewが見つかりません。インストールを開始します..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [ -n "$ZSH_VERSION" ]; then
    SHELL_PROFILE="$HOME/.zprofile"
  else
    SHELL_PROFILE="$HOME/.bash_profile"
  fi

  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$SHELL_PROFILE"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "Homebrewをアップデートしています..."
brew update

#----------------------------
# Brewfileによるパッケージのインストール
#----------------------------

BREWFILE_PATH="$DOTFILES_DIR/Brewfile"

if [ ! -f "$BREWFILE_PATH" ]; then
  echo "Brewfileが見つかりません。$BREWFILE_PATH を確認してください。"
  exit 1
fi

echo "パッケージとアプリケーションをインストールしています..."
brew bundle --file="$BREWFILE_PATH"

#----------------------------
# Oh My Zshのインストール
#----------------------------

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Oh My Zshをインストールしています..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

#----------------------------
# fzfのシェル拡張機能をインストール
#----------------------------

if [ -f "$(brew --prefix)/opt/fzf/install" ]; then
  echo "fzfのシェル拡張機能をインストールしています..."
  yes | "$(brew --prefix)/opt/fzf/install" --all --no-bash --no-fish
fi

echo "インストールが完了しました。"
