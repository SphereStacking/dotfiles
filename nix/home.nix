{ pkgs, config, ... }:

let
  dotfilesDir = "${config.home.homeDirectory}/Develop/reps/SphereStacking/dotfiles";
in
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

  # VSCode設定をシンボリックリンク（直接リンクで編集可能に）
  home.file."Library/Application Support/Code/User/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.vscode/settings.json";
  home.file."Library/Application Support/Code/User/keybindings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.vscode/keybindings.json";

  # Claude Code カスタムコマンド・スキル
  home.file.".claude/commands".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.claude/commands";

  # AeroSpace設定（直接編集可能）
  home.file.".aerospace.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.config/aerospace/aerospace.toml";
}
