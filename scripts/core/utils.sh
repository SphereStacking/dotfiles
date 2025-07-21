#!/usr/bin/env bash
# 共通ユーティリティ関数

# 色付きメッセージ関数
info() {
    echo -e "\033[32m[情報]\033[0m $*"
}

warn() {
    echo -e "\033[33m[警告]\033[0m $*"
}

error() {
    echo -e "\033[31m[エラー]\033[0m $*"
}

success() {
    echo -e "\033[92m[完了]\033[0m $*"
}

# プログレス表示
progress() {
    local current=$1
    local total=$2
    local task=$3
    echo -e "\033[36m[$current/$total]\033[0m $task"
}

# 必要なツールの確認
check_requirements() {
    local missing=()
    
    if ! command -v git &> /dev/null; then
        missing+=("git")
    fi
    
    if ! command -v curl &> /dev/null; then
        missing+=("curl")
    fi
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        error "必要なツールが不足しています: ${missing[*]}"
        error "先にインストールしてください。"
        return 1
    fi
    
    return 0
}

# 安全なシンボリックリンク作成
create_symlink() {
    local src="$1"
    local dest="$2"
    
    # ソースファイルの存在確認
    if [[ ! -e "$src" ]]; then
        error "ソースファイルが存在しません: $src"
        return 1
    fi
    
    # 既存ファイルのバックアップ
    if [[ -e "$dest" && ! -L "$dest" ]]; then
        local backup="$dest.backup.$(date +%Y%m%d_%H%M%S)"
        mv "$dest" "$backup"
        info "既存ファイルをバックアップしました: $dest -> $backup"
    fi
    
    # 既存シンボリックリンクの削除
    if [[ -L "$dest" ]]; then
        rm "$dest"
    fi
    
    # 親ディレクトリの作成
    mkdir -p "$(dirname "$dest")"
    
    # シンボリックリンク作成（絶対パス使用）
    ln -sfn "$src" "$dest"
    info "シンボリックリンクを作成しました: $dest -> $src"
}

# 環境検出
detect_os() {
    case "$OSTYPE" in
        darwin*)
            echo "macos"
            ;;
        linux*)
            if [[ -n "${WSL_DISTRO_NAME:-}" ]]; then
                echo "wsl2"
            else
                echo "linux"
            fi
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# パッケージが既にインストールされているかチェック
is_installed() {
    command -v "$1" &> /dev/null
}

# 確認付きインストール
install_if_missing() {
    local package="$1"
    local install_cmd="$2"
    
    if ! is_installed "$package"; then
        info "$package をインストール中..."
        eval "$install_cmd"
    else
        info "$package は既にインストールされています"
    fi
}