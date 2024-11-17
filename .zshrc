# 環境変数の設定
export EDITOR="cursor"
export DOTFILES_PATH="$HOME/dotfiles"

export HISTSIZE=1000
export SAVEHIST=1000

# 各設定ファイルを読み込む
source "$HOME/.zsh/rc/oh-my-zsh.zsh"
# source "$HOME/.zsh/rc/fzf.zsh"
# source "$HOME/.zsh/rc/fzf-git.sh"
source "$HOME/.zsh/rc/alias.zsh"
source "$HOME/.zsh/rc/functions.zsh"


# カレントディレクトリをタイトルに表示する
function set_win_title(){
  echo -ne "\033]0; $(basename "$PWD") \007"
}
precmd_functions+=(set_win_title)

# sheldonの初期化
eval "$(sheldon source)"

# Starshipを初期化
eval "$(starship init zsh)"
