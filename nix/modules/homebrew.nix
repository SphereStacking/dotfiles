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
      "FelixKratz/formulae"
    ];
    brews = [
      "felixkratz/formulae/borders"
      "felixkratz/formulae/sketchybar"
      "fzf"
      "bat"
      "eza"
      "ripgrep"
      "fd"
      "zoxide"
      "dust"
      "duf"
      "bottom"
      "git-delta"
      "tldr"
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
      "font-symbols-only-nerd-font"
      "font-hack-nerd-font"
      "font-sf-pro"
      "sf-symbols"
    ];
  };
}
