# macOS固有の設定

# Homebrewの設定
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# macOS固有のパス設定
# 必要に応じてmacOS固有の設定を追加