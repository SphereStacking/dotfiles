# 環境変数の設定
export EDITOR="cursor"
export DOTFILES_PATH="$HOME/dotfiles"

# Starshipを初期化
eval "$(starship init zsh)"

# 各設定ファイルを読み込む
source "$DOTFILES_PATH/.zsh/rc/oh-my-zsh.zsh"
source "$DOTFILES_PATH/.zsh/rc/fzf.zsh"
source "$DOTFILES_PATH/.zsh/rc/fzf-git.sh"
source "$DOTFILES_PATH/.zsh/rc/starship.zsh"
source "$DOTFILES_PATH/.zsh/rc/editor.zsh"
source "$DOTFILES_PATH/.zsh/rc/alias.zsh"
source "$DOTFILES_PATH/.zsh/rc/functions.zsh"
source "$DOTFILES_PATH/.zsh/rc/cheatsheets.zsh"
