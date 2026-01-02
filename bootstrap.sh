#!/bin/bash
#----------------------------
# Nix + nix-darwin セットアップスクリプト
#----------------------------

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "==> Dotfilesディレクトリ: $DOTFILES_DIR"

# 1. Nixインストール確認
if ! command -v nix &>/dev/null; then
  echo "==> Nixをインストール中..."
  curl -L https://nixos.org/nix/install | sh -s -- --daemon
  echo "==> Nixインストール完了。シェルを再起動してから再度実行してください。"
  exit 0
fi

# 2. Homebrewインストール確認
if ! command -v brew &>/dev/null; then
  echo "==> Homebrewをインストール中..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # PATHに追加（Apple Silicon）
  if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
fi

# 3. nix-darwin適用
echo "==> nix-darwin設定を適用中..."
sudo nix --extra-experimental-features "nix-command flakes" run nix-darwin/master#darwin-rebuild -- switch --flake "$DOTFILES_DIR/nix"

echo "==> セットアップ完了！"
echo "新しいターミナルを開いてください。"
