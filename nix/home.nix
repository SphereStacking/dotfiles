{ pkgs, ... }:

{
  imports = [
    ./modules/zsh.nix
    ./modules/git.nix
    ./modules/starship.nix
  ];

  home.username = "sphere";
  home.homeDirectory = "/Users/sphere";
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    sheldon
  ];

  # Sheldon設定をシンボリックリンク
  home.file.".config/sheldon/plugins.toml".source = ../sheldon/plugins.toml;

  # VSCode設定をシンボリックリンク
  home.file."Library/Application Support/Code/User/settings.json".source = ../.vscode/settings.json;
  home.file."Library/Application Support/Code/User/keybindings.json".source = ../.vscode/keybindings.json;
}
