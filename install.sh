#!/usr/bin/env bash
set -ue

# dotfiles installer - 統合インストーラー
# 環境自動検出、プログレス表示、エラーハンドリング付き

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$SCRIPT_DIR"

# 共通ユーティリティの読み込み
# shellcheck source=scripts/core/utils.sh
source "$DOTFILES_DIR/scripts/core/utils.sh"

# 個別インストールスクリプトの実行
run_installer() {
    local script_name="$1"
    local script_path="$DOTFILES_DIR/scripts/install/$script_name"
    
    if [[ -f "$script_path" ]]; then
        info "$script_name を実行中..."
        # shellcheck source=/dev/null
        source "$script_path"
        
        # スクリプト内の関数名を推定（setup_xxxの形式）
        local function_name
        function_name=$(basename "$script_name" .sh)
        
        if declare -f "$function_name" > /dev/null; then
            "$function_name"
        else
            warn "$script_name に関数 $function_name が見つかりません"
        fi
    else
        error "スクリプトが見つかりません: $script_path"
        return 1
    fi
}

# 完全インストール
install_all() {
    local os
    os=$(detect_os)
    info "検出されたOS: $os"
    
    local scripts=()
    case "$os" in
        macos)
            scripts=(
                "setup_homebrew.sh"
                "setup_brewfile.sh"
                "setup_oh_my_zsh.sh"
                "setup_asdf.sh"
            )
            ;;
        wsl2)
            scripts=(
                "setup_wsl2.sh"
                "setup_oh_my_zsh.sh"
                "setup_asdf.sh"
            )
            ;;
        linux)
            scripts=(
                "setup_oh_my_zsh.sh"
                "setup_asdf.sh"
            )
            ;;
        *)
            error "サポートされていないOS: $os"
            return 1
            ;;
    esac
    
    # シンボリックリンクは共通
    scripts+=("setup_create_symlink_dotfiles.sh")
    
    local total=${#scripts[@]}
    local current=0
    
    for script in "${scripts[@]}"; do
        ((current++))
        progress "$current" "$total" "$script をインストール中"
        
        if ! run_installer "$script"; then
            error "$script の実行に失敗しました"
            return 1
        fi
    done
    
    # 新しいリンク管理スクリプトでリンク作成
    info "新しいリンク管理システムでシンボリックリンクを作成中..."
    "$DOTFILES_DIR/scripts/core/link.sh" create
    
    success "全てのインストールが完了しました！"
}

# 最小インストール
install_minimal() {
    info "最小構成をインストール中..."
    
    # シンボリックリンクのみ作成
    "$DOTFILES_DIR/scripts/core/link.sh" create
    
    success "最小構成のインストールが完了しました！"
}

# 更新
update() {
    info "dotfilesを更新中..."
    
    # Gitで最新を取得
    if git -C "$DOTFILES_DIR" pull; then
        info "dotfilesリポジトリを更新しました"
    else
        warn "リポジトリの更新に失敗しました。ローカル版で続行します"
    fi
    
    # リンクの更新
    "$DOTFILES_DIR/scripts/core/link.sh" create
    
    success "更新が完了しました！"
}

# ヘルプメッセージ
help() {
    echo "使用方法: $0 [オプション]"
    echo ""
    echo "オプション:"
    echo "  --all, -a      完全インストール（デフォルト）"
    echo "  --minimal, -m  最小インストール（シンボリックリンクのみ）"
    echo "  --update, -u   既存インストールの更新"
    echo "  --help, -h     このヘルプメッセージを表示"
    echo ""
    echo "対話モード（引数なし）:"
    echo "  インストールタイプを対話的に選択"
}

# 対話モード
interactive_mode() {
    echo "=== dotfiles インストーラー ==="
    echo ""
    echo "インストールタイプを選択してください："
    echo "1) 完全インストール（新規セットアップ推奨）"
    echo "2) 最小インストール（シンボリックリンクのみ）"
    echo "3) 既存インストールの更新"
    echo "4) 終了"
    echo ""
    
    while true; do
        read -rp "選択肢を入力してください (1-4): " choice
        
        case "$choice" in
            1)
                install_all
                break
                ;;
            2)
                install_minimal
                break
                ;;
            3)
                update
                break
                ;;
            4)
                info "インストールがキャンセルされました。"
                exit 0
                ;;
            *)
                warn "無効な選択です。1-4を入力してください。"
                ;;
        esac
    done
}

# メイン処理
main() {
    # 要件チェック
    if ! check_requirements; then
        exit 1
    fi
    
    # コマンドライン引数の処理
    case "${1:-interactive}" in
        --all|-a)
            install_all
            ;;
        --minimal|-m)
            install_minimal
            ;;
        --update|-u)
            update
            ;;
        --help|-h)
            help
            ;;
        interactive)
            interactive_mode
            ;;
        *)
            error "不明なオプション: $1"
            help
            exit 1
            ;;
    esac
}

main "$@"
