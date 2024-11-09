# -------------------------------- #
# CheatSheets
# -------------------------------- #

# .mdを表示するための関数
function cheat() {
  local path="$DOTFILES_PATH/CheatSheets"
  local preview="bat --style=numbers --color=always --line-range :500"
  local file=$(find "$path" -type f -name "*.md" | fzf --preview "$preview")

  if [[ -n $file ]]; then
    bat --style=plain "$file"
  else
    echo "No file selected."
  fi
}

# .mdファイルからコマンドを検索して実行するための関数
function cheat_exec() {

  local path="$DOTFILES_PATH/CheatSheets"
  local preview="bat --style=numbers --color=always --line-range :500"
  local file=$(find "$path" -type f -name "*.md" | fzf --preview "$preview")
  
  if [[ -n $file ]]; then
    local command
    local find_start='<!-- exec:start -->'
    local find_end='<!-- exec:end -->'
    command=$(awk "/$find_start/,/$find_end/ {if (\$0 ~ /\\|/) print \$3}" "$file" | fzf)
    if [[ -n $command ]]; then
      # プレースホルダーを探して値を入力
      while [[ $command =~ <([^>]+)> ]]; do
        local placeholder="${BASH_REMATCH[1]}"
        read -p "Enter value for $placeholder: " value
        command="${command//<$placeholder>/$value}"
      done
      eval "$command"
    else
      echo "No command selected."
    fi
  else
    echo "No file selected."
  fi
}
