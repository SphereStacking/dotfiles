# dotfiles main configuration file
# 環境を判定して適切な設定ファイルを読み込む

# 共通設定の読み込み
source "$HOME/shell/common/init.zsh"

# OS別の設定読み込み
case "$OSTYPE" in
    darwin*)
        # macOS
        source "$HOME/shell/macos/init.zsh"
        ;;
    linux*)
        # Linux (WSL2含む)
        if [[ -n "$WSL_DISTRO_NAME" ]]; then
            # WSL2
            source "$HOME/shell/wsl2/init.zsh"
        else
            # 通常のLinux
            # 必要に応じて追加
        fi
        ;;
esac
