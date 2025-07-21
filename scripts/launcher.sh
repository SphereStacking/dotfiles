#!/usr/bin/env bash

# 統合コマンドランチャー - YAMLファイルベース設定でfzfを使用

set -euo pipefail

# 共通ユーティリティの読み込み
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=core/utils.sh
source "$SCRIPT_DIR/core/utils.sh"

# 設定ファイルパス
CONFIG_FILE="$SCRIPT_DIR/../config/launcher/commands.yml"

# YAMLパーサー（シンプルな実装）
parse_yaml() {
    local file="$1"
    local category="${2:-}"
    
    if [[ ! -f "$file" ]]; then
        error "設定ファイルが見つかりません: $file"
        exit 1
    fi
    
    if [[ -n "$category" ]]; then
        # 特定カテゴリのみ表示
        awk -v cat="$category:" '
        $0 == cat {found=1; next} 
        found && /^[a-zA-Z]/ && !/^  / {found=0} 
        found && /^  / {
            gsub(/^  /, "")
            gsub(/"/, "")
            split($0, parts, ": ")
            printf "[%s] %-20s %s\n", substr(cat,1,length(cat)-1), parts[1], parts[2]
        }' "$file"
    else
        # 全カテゴリ表示
        awk '
        /^[a-zA-Z][^:]*:$/ {
            category = substr($0, 1, length($0)-1)
            next
        }
        /^  / && category != "" {
            gsub(/^  /, "")
            gsub(/"/, "")
            split($0, parts, ": ")
            printf "[%s] %-20s %s\n", category, parts[1], parts[2]
        }' "$file"
    fi
}

# カテゴリ一覧を取得
get_categories() {
    awk '/^[a-zA-Z][^:]*:$/ {print substr($0, 1, length($0)-1)}' "$CONFIG_FILE"
}

# fzfが利用可能かチェック
if ! command -v fzf &> /dev/null; then
    error "fzfがインストールされていません。先にfzfをインストールしてください。"
    exit 1
fi

# カテゴリ選択
select_category() {
    get_categories | fzf \
        --height=30% \
        --layout=reverse \
        --prompt="Category > " \
        --header="カテゴリを選択してください (Ctrl+A で全表示)"
}

# 引数が必要かチェック
needs_args() {
    local cmd="$1"
    [[ "$cmd" == *"["*"]"* ]]
}

# 引数を抽出
extract_args() {
    local description="$1"
    echo "$description" | grep -o '\[.*\]' | sed 's/\[//g; s/\]//g'
}

# コマンド実行の特殊処理
execute_command() {
    local cmd="$1"
    local args="${2:-}"
    
    case "$cmd" in
        "gcob")
            git checkout -b "$args"
            ;;
        "gcm")
            git commit -m "$args"
            ;;
        "dcr")
            docker compose run --rm "$args"
            ;;
        "dce")
            docker compose exec "$args" bash
            ;;
        "dr")
            docker rm "$args"
            ;;
        "dri")
            docker rmi "$args"
            ;;
        "source venv/bin/activate")
            # bashの制限回避
            echo "source venv/bin/activate を実行してください"
            return 0
            ;;
        *)
            # aliasがあるかチェックして実行
            if alias "$cmd" &>/dev/null 2>&1; then
                eval "$cmd"
            elif command -v "$cmd" &>/dev/null; then
                eval "$cmd"
            else
                # 複数単語コマンドの場合
                eval "$cmd"
            fi
            ;;
    esac
}

# メイン処理
main() {
    info "統合コマンドランチャー"
    
    # 使用方法表示
    if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
        echo "使用方法:"
        echo "  $(basename "$0")              # 全コマンド一覧から検索選択"
        exit 0
    fi
    
    echo "実行したいコマンドを選択してください (入力で検索):"
    echo ""
    
    # 全コマンド表示
    commands=$(parse_yaml "$CONFIG_FILE")
    
    if [[ -z "$commands" ]]; then
        error "コマンドが見つかりません"
        exit 1
    fi
    
    # コマンド選択（検索機能付き）
    selected=$(echo "$commands" | fzf \
        --height=80% \
        --layout=reverse \
        --prompt="Search & Select > " \
        --preview-window="right:50%" \
        --preview="echo {3..}" \
        --header="文字入力で検索, ↑↓で選択, Enterで実行, Escでキャンセル")
    
    if [[ -z "$selected" ]]; then
        warn "キャンセルしました"
        exit 0
    fi
    
    # 選択されたコマンドを抽出
    selected_cmd=$(echo "$selected" | awk '{print $2}')
    selected_desc=$(echo "$selected" | awk '{for(i=3;i<=NF;i++) printf "%s ", $i; print ""}' | sed 's/ $//')
    
    # 引数が必要なコマンドの場合は入力を求める
    local args=""
    if needs_args "$selected_desc"; then
        arg_hint=$(extract_args "$selected_desc")
        read -r -p "${arg_hint}を入力してください: " args
        if [[ -z "$args" ]]; then
            error "引数が必要です"
            exit 1
        fi
    fi
    
    echo ""
    info "実行コマンド: $selected_cmd ${args:-}"
    echo ""
    
    # コマンド実行
    execute_command "$selected_cmd" "$args"
    
    success "コマンドが完了しました"
}

# スクリプトが直接実行された場合のみmain関数を呼び出し
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
