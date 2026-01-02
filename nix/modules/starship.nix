{ ... }:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      continuation_prompt = "[❯❯ ](fg:blue)";

      character = {
        error_symbol = "[❯❯❯](bold red)";
        success_symbol = "[❯❯❯](bold green)";
      };

      directory = {
        style = "fg:blue";
        format = "[$path]($style)";
        truncation_length = 4;
        truncation_symbol = "...";
        truncate_to_repo = false;
      };

      git_status = {
        style = "fg:blue";
        format = "([\\[$all_status$ahead_behind\\]]($style))";
      };

      git_branch = {
        format = " [$symbol $branch]($style)";
        style = "fg:#888888";
        symbol = "";
      };

      git_metrics = {
        disabled = false;
        added_style = "bold blue";
        format = "\\([+$added]($added_style)/[-$deleted]($deleted_style)\\)";
        only_nonzero_diffs = true;
      };

      nodejs = {
        style = "#ffc0cb";
        format = " [$symbol $version]($style)";
        symbol = "";
      };

      python = {
        detect_extensions = ["py" "ipynb"];
        pyenv_version_name = true;
        style = "yellow";
        format = " [\${symbol}\${pyenv_prefix}(\${version} )(\\($virtualenv\\) )]($style)";
      };

      docker_context = {
        format = "via [🐋 $context](blue bold)";
      };

      cmd_duration = {
        show_milliseconds = true;
        format = " [󱫌 $duration]($style)";
      };
    };
  };
}
