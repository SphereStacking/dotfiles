{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    shellAliases = {
      cat = "bat";
      ls = "eza --icons";
      ll = "eza -alh --icons";
      la = "eza -a --icons";
      tree = "eza --tree --icons";
      grep = "rg";
      find = "fd";
      du = "dust";
      df = "duf";
      top = "btm";
      diff = "delta";
      ss = "~/Develop/reps/SphereStacking/dotfiles/launcher.sh";
    };
    history = {
      size = 10000;
      save = 10000;
    };
    initContent = ''
      # Sheldon plugin manager
      eval "$(sheldon source)"

      # Homebrew PATH
      export PATH="/opt/homebrew/bin:$PATH"

      # zoxide (smarter cd)
      eval "$(zoxide init zsh)"

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

    '';
  };
}
