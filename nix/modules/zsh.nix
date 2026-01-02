{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    history = {
      size = 10000;
      save = 10000;
    };
    initContent = ''
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
    plugins = [
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "0.8.0";
          sha256 = "sha256-iJdWopZwHpSyYl5/FQXEW7gl/SrKaYDEtTH9cGP7iPo=";
        };
      }
      {
        name = "zsh-autocomplete";
        src = pkgs.fetchFromGitHub {
          owner = "marlonrichert";
          repo = "zsh-autocomplete";
          rev = "24.09.04";
          sha256 = "sha256-o8IQszQ4/PLX1FlUvJpowR2Tev59N8lI20VymZ+Hp4w=";
        };
      }
      {
        name = "zsh-completions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-completions";
          rev = "0.35.0";
          sha256 = "sha256-GFHlZjIHUWwyeVoCpszgn4AmLPSSE8UVNfRmisnhkpg=";
        };
      }
      {
        name = "zsh-z";
        src = pkgs.fetchFromGitHub {
          owner = "agkozak";
          repo = "zsh-z";
          rev = "afaf2965b41fdc6ca66066e09382726aa0b6aa04";
          sha256 = "sha256-FnGjp/VJLPR6FaODY0GtCwcsTYA4d6D8a6dMmNpXQ+g=";
        };
      }
      {
        name = "zsh-history-substring-search";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-history-substring-search";
          rev = "v1.1.0";
          sha256 = "sha256-GSEvgvgWi1rrsgikTzDXokHTROoyPRlU0FVpAoEmXG4=";
        };
      }
      {
        name = "zsh-abbr";
        src = pkgs.fetchFromGitHub {
          owner = "olets";
          repo = "zsh-abbr";
          rev = "v5.8.1";
          sha256 = "sha256-gqBOWfmhYwnrdu/KIwfbl6R/kCt49b/3+ANwcmcxxhY=";
        };
      }
    ];
  };
}
