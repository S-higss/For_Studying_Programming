# Dockerトラブルシューティング

Dockerに関連するトラブルシューティングをまとめています．  
Dockerのインストールに関しては[Dockerのインストール](../env/README.md#dockerのインストール)を参照してください．

## 目次

- [Dockerの容量不足解決](#dockerの容量不足解決)
- [Windows環境にてDockerに占領されたディスク領域を解放する](#windows環境にてdockerに占領されたディスク領域を解放する)

[HOME に戻る](../README.md)

## Dockerの容量不足解決

何度もBuildなど繰り返しているとDockerのディスク容量が増大していきます．  
そのままだと`no space left on device`のエラーメッセージとともにDockerが動作できなくなります．

そこで，Dockerの容量不足を解決する方法を下に記します．

まずDockerのディスク利用状況を確認します．

```bash
docker system df

#実行結果
TYPE            TOTAL     ACTIVE    SIZE      RECLAIMABLE
Images          11        11        14.94GB   245.5MB (1%)
Containers      11        11        11.89GB   0B (0%)
Local Volumes   3         2         1.534GB   186.5MB (12%)
Build Cache     129       0         239.1MB   239.1MB
```

これにより，イメージ，コンテナ，Localボリューム及びBuildキャッシュの利用状況がわかります．  
このコマンドに`-v`オプションをつけると，より詳細な情報が出ます．

## イメージの削除

使っていないイメージがあれば．以下のコマンドでクリーンアップできます．　　
使っていないイメージとは，タグを持たず，他コンテナからの参照がないイメージです．

```bash
docker image prune

WARNING! This will remove all dangling images.
Are you sure you want to continue? [y/N] y
```

既存のコンテナから使っていないイメージまですべて削除するには`-a`オプションをつけて実行します．

```bash
docker image prune -a

WARNING! This will remove all images without at least one container associated to them.
Are you sure you want to continue? [y/N] y
```

## コンテナの削除

コンテナの起動時に`--rm`オプションをつけていなければコンテナは自動的に削除されません．  
実行中のコンテナを表示する`docker ps`コマンドに`-a`オプションをつけた，  
`docker ps -a`を実行すると，使用していないコンテナまで表示されます．

これらを削除するには以下のコマンドを使用します．

```bash
# 不要コンテナの削除
docker container prune
```

## ボリュームの削除

ボリュームは1つもしくは複数のコンテナにより利用されるものであり，  
その削除はデータの破棄にあたるので，決して自動的に削除はされません．  

これらを削除するには以下のコマンドを使用します．

```bash
# 不要コンテナの削除
docker volume prune
```

## ネットワークの削除

Dockerネットワークはディスクスペースを消費しませんが，  
`iptables`ルールを作成し，ブリッジ・ネットワークのデバイスおよびルーティング・テーブルのエントリも作成します．

これらを削除するには以下のコマンドを使用します．

```bash
# 不要コンテナの削除
docker network prune
```

## 全てを削除

イメージ，コンテナ，ネットワークを削除するには，以下のコマンドが使用できます．  
ただし，ボリュームはデフォルトで削除されないので，`--volumes`オプションを使用します．

```bash
# Delete image/container/network
docker system prune

# Delete image/container/network/volume
docker system prune --volumes
```

## 確認

最後にディスク利用状況を再確認し，削除を確認します．

```bash
docker system df
TYPE                TOTAL               ACTIVE              SIZE                RECLAIMABLE
Images              0                   0                   0B                  0B
Containers          0                   0                   0B                  0B
Local Volumes       0                   0                   0B                  0B
Build Cache         0                   0                   0B       
```

[目次 に戻る](#目次)

[TOP に戻る](./README.md)

[HOME に戻る](../README.md)

## Windows環境にてDockerに占領されたディスク領域を解放する

工事中

[目次 に戻る](#目次)

[TOP に戻る](./README.md)

[HOME に戻る](../README.md)
