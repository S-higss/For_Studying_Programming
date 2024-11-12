# Dockerトラブルシューティング

Dockerに関連するトラブルシューティングをまとめています．  
Dockerのインストールに関しては[Dockerのインストール](../env/README.md#dockerのインストール)を参照してください．

## 目次

- [Dockerの容量不足解決](#dockerの容量不足解決)
- [Windows-WSL環境にてDockerに占領されたディスク領域を解放する](#windows-wsl環境にてdockerに占領されたディスク領域を解放する)

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

[HOME に戻る](../README.md)

## Windows-WSL環境にてDockerに占領されたディスク領域を解放する

Windowsにて，WSL2を用いたLinux環境でDockerを扱っていると，上記手段ではマシンの容量が戻りません．  
というのもWSL2は一度確保したディスクをホストに返さないため，Dockerで圧迫した容量も返却されないというわけです．

[WSL2 Docker が PC のディスクを圧迫する - Qiita](https://qiita.com/sarisia/items/5c53c078ab30eb26bc3b)では，  
Hyper-Vを用いて解決を図っていますが，Hyper-Vが入っているのはWindows Proだけであるため，  
その他の環境では以下の方法で解決を図ることになります．

### WSLのshutdown

まずディスクを使用している根本原因であるWSLをshutdownします．

```bash
wsl --shutdown
```

### diskpartの起動及びext4.vhdxの圧縮

WSLのディスク占領の元凶は`ext4.vhdx`というファイルです．  
diskpartを用いてディスクを圧縮し，空きスペースを確保するのですが，このディスクの場所を探す必要があります．  
`C:\Users\<user_name>\AppData\Local\Docker\wsl\data`配下に存在すると思われます．  
ここにない場合は他の場所を探してください．  

```bash
diskpart
```

コマンドを実行すると，diskpart.exeが実行状態になり，専用のコマンドラインが出現します．  
ここで，先ほど確認した`ext4.vhdx`のパスを用いて

```bash
DISKPART> select vdisk file="C:\Users\<user_name>\AppData\Local\Docker\wsl\data\ext4.vhdx"
DISKPART> attach vdisk readonly
DISKPART> compact vdisk
DISKPART> detach vdisk
DISKPART> exit
```

を実行するとディスク領域の開放が完了します．

[目次 に戻る](#目次)

[HOME に戻る](../README.md)
