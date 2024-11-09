#!/bin/bash

# dotfilesインストールスクリプト

# リポジトリのディレクトリを取得
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "dotfilesディレクトリ: $DOTFILES_DIR"

#----------------------------
# シンボリックリンクの作成
#----------------------------
create_symlink() {
  local source=$1
  local target=$2

  if [ -f "$target" ] && [ ! -L "$target" ]; then
    mv "$target" "$target.backup"
    echo "既存の $(basename "$target") をバックアップしました。"
  fi

  ln -snf "$source" "$target"
  echo "$(basename "$target") のシンボリックリンクを作成しました。"
}

echo "シンボリックリンクを作成しています..."

# 必要なディレクトリを作成
mkdir -p "$HOME/.vscode" \
         "$HOME/.config" \
         "$HOME/dotfiles/scripts"

# ファイルのマッピングを定義
FILE_MAP=(
  # ホームディレクトリ
  "$DOTFILES_DIR/.gitconfig"                "$HOME/.gitconfig"
  "$DOTFILES_DIR/.zshrc"                    "$HOME/.zshrc"
  # vscode
  "$DOTFILES_DIR/.vscode/settings.json"     "$HOME/.vscode/settings.json"
  "$DOTFILES_DIR/.vscode/extensions.json"   "$HOME/.vscode/extensions.json"
  # config
  "$DOTFILES_DIR/.config/starship.toml"     "$HOME/.config/starship.toml"
  # scripts
  "$DOTFILES_DIR/scripts/fzf-git.sh"        "$HOME/dotfiles/scripts/fzf-git.sh"
  # 必要に応じて他のファイルを追加
)

# シンボリックリンクを作成
for ((i=0; i<${#FILE_MAP[@]}; i+=2)); do
  source="${FILE_MAP[i+1]}"
  target="${FILE_MAP[i]}"
  create_symlink "$source" "$target"
done

echo "シンボリックリンクの作成が完了しました。"

#----------------------------
# Homebrewのインストールと設定
#----------------------------

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
