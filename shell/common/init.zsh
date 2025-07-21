# 共通環境変数の設定
export EDITOR="cursor"
export DOTFILES_PATH="$HOME/dotfiles"

# 日本語環境設定（利用可能な場合のみ）
if locale -a | grep -q "ja_JP.utf8\|ja_JP.UTF-8"; then
    export LANG=ja_JP.UTF-8
    export LC_ALL=ja_JP.UTF-8
fi

export HISTSIZE=1000
export SAVEHIST=1000

# 各設定ファイルを読み込む
[[ -f "$HOME/shell/rc/oh-my-zsh.zsh" ]] && source "$HOME/shell/rc/oh-my-zsh.zsh"
# [[ -f "$HOME/shell/rc/fzf.zsh" ]] && source "$HOME/shell/rc/fzf.zsh"
# [[ -f "$HOME/shell/rc/fzf-git.sh" ]] && source "$HOME/shell/rc/fzf-git.sh"
[[ -f "$HOME/shell/rc/alias.zsh" ]] && source "$HOME/shell/rc/alias.zsh"
[[ -f "$HOME/shell/rc/functions.zsh" ]] && source "$HOME/shell/rc/functions.zsh"

# カレントディレクトリをタイトルに表示する
function set_win_title(){
  echo -ne "\033]0; $(basename "$PWD") \007"
}
precmd_functions+=(set_win_title)

# sheldonの初期化
if command -v sheldon &> /dev/null; then
    eval "$(sheldon source)"
fi

# asdfの初期化
if [[ -f "$HOME/.asdf/asdf.sh" ]]; then
    source "$HOME/.asdf/asdf.sh"
fi

# Starshipを初期化
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi
