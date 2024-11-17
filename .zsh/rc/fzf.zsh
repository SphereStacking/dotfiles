# fzfの設定ファイルを読み込む
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# fzfのキー・バインディングと補完を有効化
if [ -f "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh" ]; then
  source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"
fi

if [ -f "$(brew --prefix)/opt/fzf/shell/completion.zsh" ]; then
  source "$(brew --prefix)/opt/fzf/shell/completion.zsh"
fi
