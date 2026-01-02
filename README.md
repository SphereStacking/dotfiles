# dotfiles

Nix (nix-darwin + home-manager) を使用した macOS 開発環境管理

## 特徴

- **nix-darwin**: macOSシステム設定の宣言的管理
- **home-manager**: ユーザー設定ファイルの管理
- **Homebrew統合**: GUI アプリケーションを Nix で宣言的に管理
- **モジュール構成**: 設定を機能別に分割して管理

## 前提条件

- **macOS** (Apple Silicon)
- **Git**

## インストール

```bash
# リポジトリをクローン
git clone https://github.com/SphereStacking/dotfiles.git ~/dotfiles
cd ~/dotfiles

# セットアップスクリプトを実行
./bootstrap.sh
```

## ファイル構成

```
dotfiles/
├── bootstrap.sh          # 初期セットアップスクリプト
├── nix/
│   ├── flake.nix         # Flake エントリーポイント
│   ├── darwin.nix        # nix-darwin 設定
│   ├── home.nix          # home-manager 設定
│   └── modules/
│       ├── homebrew.nix  # Homebrew cask 管理
│       ├── system.nix    # macOS システム設定
│       ├── zsh.nix       # Zsh シェル設定
│       ├── git.nix       # Git 設定
│       └── starship.nix  # Starship プロンプト
└── .vscode/              # VSCode 設定（シンボリックリンク）
```

## 設定の更新

```bash
# 設定を適用
sudo darwin-rebuild switch --flake ./nix#spherenoMacBook-Pro

# Flake の構文チェック
nix flake check ./nix --no-build
```

## 管理されるアプリケーション

### Homebrew Cask (GUI アプリ)
- Claude / Claude Code
- Cursor / Visual Studio Code
- Google Chrome
- Raycast
- Ghostty
- 1Password
- Discord / Slack
- Font Cica

### Nix パッケージ (CLI ツール)
- git / gh
- starship
- rustup
- nodejs
- python3

## カスタマイズ

### アプリケーションの追加

`nix/modules/homebrew.nix` を編集:

```nix
casks = [
  "new-app"  # 追加
];
```

### システム設定の変更

`nix/modules/system.nix` を編集して `darwin-rebuild switch` を実行

### Zsh 設定の変更

`nix/modules/zsh.nix` を編集

## 注意事項

- 設定変更後は `darwin-rebuild switch` で適用が必要
- Homebrew の `cleanup = "zap"` により、リストにないアプリは削除されます
- VSCode 設定は `~/.vscode/` からシンボリックリンクされます
