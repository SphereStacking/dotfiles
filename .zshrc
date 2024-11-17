# 環境変数の設定
export EDITOR="cursor"
export DOTFILES_PATH="$HOME/dotfiles"


# 各設定ファイルを読み込む
source "$DOTFILES_PATH/.zsh/rc/oh-my-zsh.zsh"
source "$DOTFILES_PATH/.zsh/rc/fzf.zsh"
source "$DOTFILES_PATH/.zsh/rc/fzf-git.sh"
source "$DOTFILES_PATH/.zsh/rc/alias.zsh"
source "$DOTFILES_PATH/.zsh/rc/functions.zsh"


# カレントディレクトリをタイトルに表示する
function set_win_title(){
  echo -ne "\033]0; $(basename "$PWD") \007"
}
precmd_functions+=(set_win_title)

# sheldonの初期化
eval "$(sheldon source)"

# Starshipを初期化
eval "$(starship init zsh)"
