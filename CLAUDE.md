# CLAUDE.md

このファイルは、このリポジトリでClaude Code (claude.ai/code) が作業する際のガイダンスを提供します。

## リポジトリ概要

開発環境の設定を管理するためのdotfilesリポジトリです。以下を含みます：
- シェル設定 (zsh)
- Homebrewによるパッケージ管理
- 開発ツールの設定
- 自動セットアップ用のインストールスクリプト

## 主要コマンド

### インストールとセットアップ

```bash
# 対話モードでのインストール（推奨）
./install.sh

# または、ワンライナーでの完全インストール
./install.sh --all

# 最小構成（シンボリックリンクのみ）
./install.sh --minimal

# 既存環境の更新
./install.sh --update
```

### リンク管理

```bash
# シンボリックリンクの状態確認
./scripts/core/link.sh status

# シンボリックリンクの作成
./scripts/core/link.sh create

# 壊れたリンクのクリーンアップ
./scripts/core/link.sh clean

# リンクの健全性チェック
./scripts/core/link.sh check
```

### 設定の再読み込み

```bash
source ~/.zshrc    # zsh設定の再読み込み
```

## アーキテクチャと構造

### ディレクトリ構造
- `scripts/` - インストール・セットアップスクリプト
  - `core/` - コア機能（リンク管理など）
  - `install/` - インストール用スクリプト
  - `utils/` - ユーティリティ
- `shell/` - シェル設定ファイル
  - `common/` - 共通設定
  - `macos/` - macOS固有設定
  - `wsl2/` - WSL2固有設定
- `config/` - アプリケーション設定（Starship、Sheldon等）
- `docs/` - ドキュメント（各種ツールのチートシート）
- `tests/` - テストスクリプト
- `.claude/` - Claude固有の設定（グローバルルールを含む）
- `Brewfile` - Homebrewパッケージ宣言

### 設定フロー
1. `.zshrc`がシェル設定のメインエントリーポイント
2. 環境を自動検出（macOS/WSL2/Linux）
3. `shell/common/init.zsh`で共通設定を読み込み
4. 環境別設定を追加読み込み（`shell/macos/`、`shell/wsl2/`）
5. `sheldon`でzshプラグイン管理
6. `starship`でプロンプトカスタマイズ

### シンボリックリンク管理
新しい`scripts/core/link.sh`スクリプトが改善されたリンク管理を提供：
- 安全なバックアップ機能（タイムスタンプ付き）
- リンク状態の可視化
- 壊れたリンクの自動検出・削除
- リンクの健全性チェック

## 重要な注意事項

### .claude/CLAUDE.mdのグローバルルール
このリポジトリには、全てのユーザーリクエストに適用されるグローバル解釈ルールが含まれています：
- 曖昧な要求は実装前に必ず確認
- 要求されていない機能やリファクタリングは追加しない
- 最小実行原則：明示的に要求されたことのみ実行

### このリポジトリでの作業
- dotfiles修正時は`./scripts/core/link.sh create`でシンボリックリンクを更新
- `./install.sh --update`で環境全体を更新可能
- macOS、WSL2、Linuxの3環境をサポート
- 設定変更はシェル再読み込みで反映
- テストスクリプト（`./tests/install_test.sh`）で健全性を確認

### 設定済み開発ツール
- エディタ: Cursor（$EDITORとして設定）
- シェル: Zsh with Oh My Zsh
- パッケージマネージャー: Homebrew（macOS）
- バージョンマネージャー: asdf、nvm
- 言語: Go、Node.js（nvm経由）、Rust（rustup経由）
