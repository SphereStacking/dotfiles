{ ... }:

{
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
    };
    taps = [
      "nikitabobko/tap"
    ];
    casks = [
      "nikitabobko/tap/aerospace"
      "claude"
      "claude-code"
      "cursor"
      "visual-studio-code"
      "google-chrome"
      "raycast"
      "ghostty"
      "1password"
      "discord"
      "slack"
      "font-cica"
      "font-moralerspace"
    ];
  };
}
