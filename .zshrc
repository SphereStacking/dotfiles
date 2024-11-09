# Oh My Zshの設定
export ZSH="$HOME/.oh-my-zsh"

# プラグインの設定
plugins=(
  git
  zsh-autocomplete
  zsh-syntax-highlighting
  zsh-z
)

# Oh My Zshを読み込み
source $ZSH/oh-my-zsh.sh

# fzfのキー・バインディングと補完を有効化
if [ -f "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh" ]; then
  source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"
fi

if [ -f "$(brew --prefix)/opt/fzf/shell/completion.zsh" ]; then
  source "$(brew --prefix)/opt/fzf/shell/completion.zsh"
fi

# fzf-git.shを読み込み
source "$HOME/dotfiles/scripts/fzf-git.sh"

# Starshipを初期化
eval "$(starship init zsh)"

# Code Editor
export EDITOR="cursor"

# -------------------------------- #
# Docker
# -------------------------------- #
alias dc='docker compose'
alias dcb='docker compose build'
alias dcr='docker compose run --rm'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dce='docker compose exec'
alias dcl='docker compose logs'
alias dps='docker ps'
alias di='docker images'
alias dr='docker rm'
alias dri='docker rmi'

# -------------------------------- #
# Git
# -------------------------------- #

# Use github/hub
alias git=hub

# Go to project root
alias grt='cd "$(git rev-parse --show-toplevel)"'

alias gs='git status'
alias gp='git push'
alias gpf='git push --force'
alias gpft='git push --follow-tags'
alias gpl='git pull --rebase'
alias gcl='git clone'
alias gst='git stash'
alias grm='git rm'
alias gmv='git mv'

alias main='git checkout main'

alias gco='git checkout'
alias gcob='git checkout -b'

alias gb='git branch'
alias gbd='git branch -d'

alias grb='git rebase'
alias grbom='git rebase origin/master'
alias grbc='git rebase --continue'

alias gl='git log'
alias glo='git log --oneline --graph'

alias grh='git reset HEAD'
alias grh1='git reset HEAD~1'

alias ga='git add'
alias gA='git add -A'

alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit -a'
alias gcam='git add -A && git commit -m'
alias gfrb='git fetch origin && git rebase origin/master'

alias gxn='git clean -dn'
alias gx='git clean -df'

alias gsha='git rev-parse HEAD | pbcopy'

alias ghci='gh run list -L 1'

function glp() {
  git --no-pager log -$1
}

function gd() {
  if [[ -z $1 ]] then
    git diff --color | diff-so-fancy
  else
    git diff --color $1 | diff-so-fancy
  fi
}

function gdc() {
  if [[ -z $1 ]] then
    git diff --color --cached | diff-so-fancy
  else
    git diff --color --cached $1 | diff-so-fancy
  fi
}

# -------------------------------- #
# Directories
#
# I put
# `~/_i` for my projects
# `~/_f` for forks
# `~/_r` for reproductions
# -------------------------------- #

function i() {
  cd ~/_i/$1
}

function repros() {
  cd ~/_r/$1
}

function forks() {
  cd ~/_f/$1
}

function pr() {
  if [ $1 = "ls" ]; then
    gh pr list
  else
    gh pr checkout $1
  fi
}

function dir() {
  mkdir $1 && cd $1
}

function clone() {
  if [[ -z $2 ]] then
    hub clone "$@" && cd "$(basename "$1" .git)"
  else
    hub clone "$@" && cd "$2"
  fi
}

# Clone to ~/i and cd to it
function clonei() {
  i && clone "$@" && $EDITOR . && cd ~2
}

function cloner() {
  repros && clone "$@" && $EDITOR . && cd ~2
}

function clonef() {
  forks && clone "$@" && $EDITOR . && cd ~2
}

function codei() {
  i && $EDITOR "$@" && cd -
}

function serve() {
  if [[ -z $1 ]] then
    live-server dist
  else
    live-server $1
  fi
}
