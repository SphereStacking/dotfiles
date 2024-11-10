# git log
function glp() {
  git --no-pager log -$1
}

# git diff
function gd() {
  if [[ -z $1 ]]; then
    git diff --color | diff-so-fancy
  else
    git diff --color $1 | diff-so-fancy
  fi
}

# git diff --cached
function gdc() {
  if [[ -z $1 ]]; then
    git diff --color --cached | diff-so-fancy
  else
    git diff --color --cached $1 | diff-so-fancy
  fi
}

# myディレクトリに移動
function i() {
  cd ~/_i/$1
}

# リポジトリディレクトリに移動
function repros() {
  cd ~/_r/$1
}

# フォークディレクトリに移動
function forks() {
  cd ~/_f/$1
}

# プルリクエストを操作
function pr() {
  if [ $1 = "ls" ]; then
    gh pr list
  else
    gh pr checkout $1
  fi
}

# ディレクトリ作成
function dir() {
  mkdir $1 && cd $1
}

# リポジトリクローン
function clone() {
  if [[ -z $2 ]]; then
    hub clone "$@" && cd "$(basename "$1" .git)"
  else
    hub clone "$@" && cd "$2"
  fi
}

# インデックスディレクトリに移動してリポジトリクローン
function clonei() {
  i && clone "$@" && $EDITOR . && cd ~2
}

# リポジトリディレクトリに移動してリポジトリクローン
function cloner() {
  repros && clone "$@" && $EDITOR . && cd ~2
}

# フォークディレクトリに移動してリポジトリクローン
function clonef() {
  forks && clone "$@" && $EDITOR . && cd ~2
}

# インデックスディレクトリに移動してコードエディタを開く
function codei() {
  i && $EDITOR "$@" && cd -
}

# ディレクトリ移動時にlsを実行
function cd() {
  builtin cd "$1" && ls
}
