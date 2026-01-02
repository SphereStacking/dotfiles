{ ... }:

{
  programs.git = {
    enable = true;
    ignores = [
      # よく誤コミットしてしまうファイル
      "*~"
      ".vscode"
      ".DS_Store"
      ".history"
      ".history/**/*"  # vscode extension local-history cache
      # 個人ファイル
      ".SphereStacking"
    ];
    settings = {
      user = {
        name = "SphereStacking";
        email = "sphere.stacking@gmail.com";
      };
      alias = {
        co = "checkout";
        st = "status";
        br = "branch";
        ci = "commit";
      };
      diff.color = true;
    };
  };
}
