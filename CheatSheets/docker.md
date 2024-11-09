# Docker

| 機能                               | コマンド                                          |
|------------------------------------|---------------------------------------------------|
| Dockerイメージのビルド             | `docker build -t <image-name> .`                  |
| Dockerコンテナの起動               | `docker run <image-name>`                         |
| バックグラウンドでコンテナを起動   | `docker run -d <image-name>`                      |
| コンテナに名前を付けて起動         | `docker run --name <container-name> <image-name>` |
| コンテナの一覧表示                 | `docker ps`                                       |
| 停止中のコンテナも含めて一覧表示   | `docker ps -a`                                    |
| コンテナの停止                     | `docker stop <container-id>`                      |
| コンテナの削除                     | `docker rm <container-id>`                        |
| イメージの一覧表示                 | `docker images`                                   |
| イメージの削除                     | `docker rmi <image-id>`                           |
| コンテナに入る                     | `docker exec -it <container-id> /bin/bash`        |
| Dockerログの表示                   | `docker logs <container-id>`                      |
| Dockerネットワークの一覧表示       | `docker network ls`                               |
| Dockerボリュームの一覧表示         | `docker volume ls`                                |
