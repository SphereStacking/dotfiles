# 既存コマンドの置き換え
alias ls='eza -alh --icons=auto --no-user'
alias cat='bat --theme="Dracula"'
alias find='fd'
alias grep='rg'

# Docker
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

# Git
alias git=hub
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

# Git便利コマンド
# マージ済みブランチを削除してブランチ一覧表示
alias gclean='git fetch --prune; git br --merged master | grep -vE "^\*|master$|develop$" | xargs -I % git branch -d % 2>/dev/null; git br --merged main | grep -vE "^\*|main$|develop$" | xargs -I % git branch -d % 2>/dev/null; git br --merged develop | grep -vE "^\*|master$|develop$" | xargs -I % git branch -d % 2>/dev/null; git br -vv'
# 最後のコミットを取り消し（変更はstaging areaに残る）
alias gundo='git reset --soft HEAD~1'
# 全変更をWIPコミットとして保存
alias gwip='git add -A && git commit -m "WIP"'
# WIPコミットを取り消し
alias gunwip='git log -n 1 | grep -q -c "WIP" && git reset HEAD~1'
# 全ブランチのグラフ付きログ表示
alias glog='git log --oneline --decorate --graph --all'
# 現在時刻をメッセージにしてstash
alias gstash='git stash push -m "$(date)"'
# 最新のstashを適用して削除
alias gpop='git stash pop'
# 単語単位で色付き差分表示
alias gdiff='git diff --word-diff=color'
# コミット詳細と変更ファイル統計を表示
alias gshow='git show --stat'

# 統合コマンドランチャー
alias launcher='$DOTFILES_PATH/scripts/launcher.sh'
alias l='$DOTFILES_PATH/scripts/launcher.sh'
