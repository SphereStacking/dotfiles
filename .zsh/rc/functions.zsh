function glp() {
  git --no-pager log -$1
}

function gd() {
  if [[ -z $1 ]]; then
    git diff --color | diff-so-fancy
  else
    git diff --color $1 | diff-so-fancy
  fi
}

function gdc() {
  if [[ -z $1 ]]; then
    git diff --color --cached | diff-so-fancy
  else
    git diff --color --cached $1 | diff-so-fancy
  fi
}

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
  if [[ -z $2 ]]; then
    hub clone "$@" && cd "$(basename "$1" .git)"
  else
    hub clone "$@" && cd "$2"
  fi
}

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
