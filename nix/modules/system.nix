{ ... }:

{
  # システム設定
  system.defaults = {
    dock = {
      autohide = true;
      show-recents = false;
    };
    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
    };
    NSGlobalDomain = {
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      _HIHideMenuBar = true;  # メニューバーを常に自動非表示
    };
    spaces = {
      spans-displays = true;  # ディスプレイごとの個別スペースを無効化（複数ディスプレイでスペースを共有）
    };
  };

  # 日本語入力のライブ変換を無効化
  system.activationScripts.extraActivation.text = ''
    echo "Disabling Japanese live conversion..."
    sudo -u sphere defaults write com.apple.inputmethod.Kotoeri JIMPrefLiveConversionKey -bool false
  '';

}
