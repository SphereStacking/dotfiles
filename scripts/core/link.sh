#!/usr/bin/env bash
set -ue

# リンク管理スクリプト
# 使い方: ./link.sh [status|create|clean|check]

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

# 共通ユーティリティの読み込み
# shellcheck source=utils.sh
source "$SCRIPT_DIR/utils.sh"

# リンク状態の表示
status() {
    info "シンボリックリンクの状態を確認中..."
    
    # 管理対象ファイルのリスト
    local files=(
        ".zshrc"
        ".gitconfig_shared"
        ".gitignore_global"
    )
    
    # ディレクトリのリスト
    local dirs=(
        "shell"
        "config"
    )
    
    # ファイルのチェック
    for file in "${files[@]}"; do
        local src="$DOTFILES_DIR/$file"
        local dest="$HOME/$file"
        
        if [[ -L "$dest" ]] && [[ "$(readlink "$dest")" = "$src" ]]; then
            echo "✓ $file -> $(readlink "$dest")"
        elif [[ -L "$dest" ]]; then
            warn "$file -> $(readlink "$dest") (壊れたリンク)"
        elif [[ -e "$dest" ]]; then
            warn "$file (存在するがリンクされていません)"
        else
            warn "$file (リンクされていません)"
        fi
    done
    
    # ディレクトリのチェック
    for dir in "${dirs[@]}"; do
        local src="$DOTFILES_DIR/$dir"
        local dest="$HOME/$dir"
        
        if [[ -L "$dest" ]] && [[ "$(readlink "$dest")" = "$src" ]]; then
            echo "✓ $dir/ -> $(readlink "$dest")"
        elif [[ -L "$dest" ]]; then
            warn "$dir/ -> $(readlink "$dest") (壊れたリンク)"
        elif [[ -d "$dest" ]]; then
            warn "$dir/ (存在するがリンクされていません)"
        else
            warn "$dir/ (リンクされていません)"
        fi
    done
}

# シンボリックリンクの作成
create() {
    info "シンボリックリンクを作成中..."
    
    # 管理対象ファイル
    create_symlink "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
    create_symlink "$DOTFILES_DIR/.gitconfig_shared" "$HOME/.gitconfig_shared"
    create_symlink "$DOTFILES_DIR/.gitignore_global" "$HOME/.gitignore_global"
    
    # ディレクトリ
    create_symlink "$DOTFILES_DIR/shell" "$HOME/shell"
    create_symlink "$DOTFILES_DIR/config" "$HOME/config"
    
    info "シンボリックリンクの作成が完了しました！"
}

# 壊れたリンクのクリーンアップ
clean() {
    info "壊れたシンボリックリンクをクリーンアップ中..."
    
    # ホームディレクトリの壊れたシンボリックリンクを検索
    find "$HOME" -maxdepth 2 -type l ! -exec test -e {} \; -print 2>/dev/null | while read -r broken_link; do
        # dotfilesからのリンクかチェック
        local target
        target=$(readlink "$broken_link" 2>/dev/null || true)
        if [[ "$target" == "$DOTFILES_DIR"* ]]; then
            warn "壊れたリンクを削除中: $broken_link -> $target"
            rm "$broken_link"
        fi
    done
    
    info "クリーンアップが完了しました！"
}

# リンクの健全性チェック
check() {
    info "シンボリックリンクの健全性をチェック中..."
    
    local errors=0
    
    # ホームディレクトリのdotfilesリンクをチェック
    find "$HOME" -maxdepth 2 -type l 2>/dev/null | while read -r link; do
        local target
        target=$(readlink "$link" 2>/dev/null || true)
        
        if [[ "$target" == "$DOTFILES_DIR"* ]]; then
            if [[ ! -e "$target" ]]; then
                error "壊れたリンク: $link -> $target"
                ((errors++))
            fi
        fi
    done
    
    if [[ $errors -eq 0 ]]; then
        info "全てのシンボリックリンクは正常です！"
    else
        error "$errors 個の壊れたシンボリックリンクが見つかりました"
        return 1
    fi
}

# ヘルプメッセージ
help() {
    echo "使用方法: $0 [コマンド]"
    echo ""
    echo "コマンド:"
    echo "  status    現在のシンボリックリンク状態を表示"
    echo "  create    シンボリックリンクを作成"
    echo "  clean     壊れたシンボリックリンクを削除"
    echo "  check     シンボリックリンクの健全性をチェック"
    echo "  help      このヘルプメッセージを表示"
}

# メイン処理
main() {
    case "${1:-help}" in
        status)
            status
            ;;
        create)
            create
            ;;
        clean)
            clean
            ;;
        check)
            check
            ;;
        help|--help|-h)
            help
            ;;
        *)
            error "不明なコマンド: $1"
            help
            exit 1
            ;;
    esac
}

main "$@"