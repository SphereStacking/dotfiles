# Oh My Zshの設定
export ZSH="$HOME/.oh-my-zsh"

# プラグインの設定
plugins=(
  git
  zsh-autocomplete
  zsh-syntax-highlighting
  zsh-z
  asdf
  zsh-abbr
)

# Oh My Zshを読み込み
source $ZSH/oh-my-zsh.sh
