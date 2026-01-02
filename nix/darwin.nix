{ pkgs, ... }:

{
  imports = [
    ./modules/homebrew.nix
    ./modules/system.nix
  ];

  # ユーザー設定（home-managerとの連携に必要）
  users.users.sphere.home = "/Users/sphere";

  # プライマリユーザー（nix-darwin新要件）
  system.primaryUser = "sphere";

  # Nix build user group GID（既存のNixインストールに合わせる）
  ids.gids.nixbld = 350;

  # Nixの設定
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # システムパッケージ
  environment.systemPackages = with pkgs; [
    git
    gh
    starship
    rustup
    nodejs_22
    python3
  ];

  # Used for backwards compatibility
  system.stateVersion = 4;
}
