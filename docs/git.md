# Git

<!-- exec:start -->
| 機能                             | コマンド                                 |
|----------------------------------|------------------------------------------|
| リポジトリの初期化               | `git init`                               |
| リポジトリをクローン             | `git clone <repository-url>`             |
| 変更をステージング               | `git add <file>`                         |
| 全ての変更をステージング         | `git add .`                              |
| 変更をコミット                   | `git commit -m "<commit-message>"`     |
| リモートリポジトリを追加         | `git remote add origin <repository-url>` |
| リモートリポジトリにプッシュ     | `git push origin <branch-name>`          |
| リモートリポジトリからプル       | `git pull origin <branch-name>`          |
| ブランチの作成                   | `git branch <new-branch-name>`           |
| ブランチの切り替え               | `git checkout <branch-name>`             |
| ブランチの作成と切り替え         | `git checkout -b <new-branch-name>`      |
| マージ                           | `git merge <branch-name>`                |
| ステージングされた変更をリセット | `git reset HEAD <file>`                  |
| コミットを取り消す               | `git revert <commit-hash>`               |
| ログの表示                       | `git log`                                |
| ステータスの確認                 | `git status`                             |
<!-- exec:end -->

## よく使うオプション

| 機能                       | コマンド               |
|----------------------------|------------------------|
| 簡潔なログ表示             | `git log --oneline`    |
| 変更点の確認               | `git diff`             |
| 作業中の変更を一時的に保存 | `git stash`            |
| 保存した変更を復元         | `git stash pop`        |
