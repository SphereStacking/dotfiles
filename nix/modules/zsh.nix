{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    history = {
      size = 10000;
      save = 10000;
    };
    initContent = ''
      # Sheldon plugin manager
      eval "$(sheldon source)"

      # Homebrew PATH
      export PATH="/opt/homebrew/bin:$PATH"

      # ディレクトリ移動時にlsを実行
      function cd() {
        builtin cd "$@" || return
        if [[ $- == *i* ]]; then ls; fi
      }

      # Claude Code CLI
      function cc() {
        local opts=()
        while [[ $# -gt 0 ]]; do
          case "$1" in
            -s) opts+=("--dangerously-skip-permissions"); shift ;;
            -c) opts+=("--continue"); shift ;;
            -r) opts+=("--resume"); shift ;;
            *)  break ;;
          esac
        done
        claude "''${opts[@]}" "$@"
      }

      # zsh-abbr abbreviations
      abbr -S ll="ls -alh" 2>/dev/null
      abbr -S la="ls -a" 2>/dev/null
    '';
  };
}
