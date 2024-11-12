# WSLトラブルシューティング

WSLに関連するトラブルシューティングをまとめています．  

## 目次

- [外部ネットワークに接続できない(Docker Desktop for Windows)](#外部ネットワークに接続できないdocker-desktop-for-windows)
- [外部ネットワークに接続できない(Name Resolution Failure)](#外部ネットワークに接続できないname-resolution-failure)

## 外部ネットワークに接続できない(Docker Desktop for Windows)

ある時WSLで開いているUbuntuで外部ネットワークに接続できなくなりました．  
具体的には，以下のような外部ネットワークに接続して実行するコマンドが通らなくなりました．

```bash
sudo apt-get update
```

原因究明のため，[なんかWSL2がインターネットにつながらなくなったときの解決方法](https://qiita.com/kotauchisunsun/items/71fae973afa00ebb871a)などを参考に試してみましたが，  
全く解決できず，

```bash
ping 8.8.8.8
```

も通らないという状況でした．

結論から言うと，**Docker Desktop for Windowsが原因**でした．  
このアプリケーションを立ち上げた瞬間からネットワークにつながらなくなっていました．

解決方法としては，Docker Desktop for Windowsを立ち上げて，  
Setting＞Resources＞WSL integrationの順に押下して表示される，  
`Enable integration with my default WSL distro`のチェックを外し(=falseにし)，  
`Enable integration with additional distros:`において，使用するディストリビューションを選択することです．

というのも，私が普段使用していたのはdefaultのディストリビューションではないのです．  
Docker Desktopのこのdefault設定のせいでWSLが外部ネットワークに接続できなくなるのは驚きですが，  
このような場合はWSL integrationを普段使用するディストリビューションに割り当てることで解決が図れます．

[目次 に戻る](#目次)

[HOME に戻る](../README.md)

## 外部ネットワークに接続できない(Name Resolution Failure)

上記のようにDocker Desktop for Windowsの設定変更により，

```bash
ping 8.8.8.8
```

が通るようになったのですが，今度は以下のコマンドが通らないという状況となりました．

```bash
ping google.com

# result
ping: google.com: Temporary failure in name resolution
```

ここからわかるのは，DNSによる名前解決ができていないということです．  
おそらく先の問題解決の際に`nameserver`を変更してしまったことが原因と考えられます．

この問題はroot権限で`/etc/resolv.conf`を編集することで解決できます．

```bash
sudo vi /etc/resolv.conf
```

で当該ファイルを開いた後に以下のように変更します．

```bash
nameserver 8.8.8.8
```

このIP `8.8.8.8`は`1.1.1.1`でもよいようです．

[目次 に戻る](#目次)

[HOME に戻る](../README.md)
