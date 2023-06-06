# 環境構築

## 目次
- [Pythonのインストール](#pythonのインストール)
- [pipのインストール](#pipのインストール)
- [makeのインストール](#makeのインストール)
- [dockerのインストール](#dockerのインストール)

## Pythonのインストール
以下はPython3.9の例ですが，
他バージョンの場合はPython3.xのxを任意の数字に置き換えてください．

### Linux環境の場合
aptを利用してインストールする場合を説明します．

#### aptをupdate

```bash
sudo apt update
sudo apt install software-properties-common
```

#### Repositoryを登録

```bash
sudo add-apt-repository ppa:deadsnakes/ppa
```

#### Python3.9をインストール

```bash
sudo apt install python3.9
```

#### Python3.9がインストールできたか確認

```bash
python3.9 --version
```

無事インストールできていれば以下のような出力がなされます．(例はv3.9.16)

```bash
Python 3.9.16
```

### Windows環境の場合
公式サイトからインストールします．
[こちら](http://netsu-n.mep.titech.ac.jp/~Kawaguchi/python/install-win/)を参考にしてください．
(参考：東京工業大学 工学院機械系 川口達也助教ページ)

[TOP に戻る](#目次)

[HOME に戻る](../README.md)

## pipのインストール
pipのインストールについては，Python3系がインストールされていることを前提に説明します．

#### pipがインストールされているかの確認

```bash
pip -V
もしくは
pip3 -V
```

pipのバージョン情報が出ればインストールされているため，__以降の操作は不要__ です．
`ModuleNotFoundError: No Module named 'pip'`と出力された等，エラーが出力された場合，次のコマンドを実行してください．

```bash
python -m pip -V
もしくは
python3 -m pip -V
```

このコマンドが実行できた場合は，__pipはインストールされているがパスが通っていない__ ことになります．その場合は[こちら]()を参照してください．
このコマンドでもエラーが出力された場合，次に進んで下さい．

#### get-pip.pyをダウンロード
- Linux環境

```bash
wget https://bootstrap.pypa.io/get-pip.py
```

- Windows環境
    1. ダウンロード先：https://bootstrap.pypa.io/get-pip.py よりget-pip.pyを任意のディレクトリに保存
    1. 保存したディレクトリで次項のコマンドを実行

#### pythonコマンドを用いてpipをインストール

```bash
python get-pip.py
```

#### pipがインストールされたかの確認
方法は，[pipがインストールされているかの確認](#pipがインストールされたかの確認)と同様です．

### pipにパスを通す方法
Windows環境では，基本的にPythonのpathが通っていればpipも動作するはずであるため，以下はLinux環境について説明しています．
次のコマンドで，pipが`~/.local/bin`配下に置かれているか確認します．

```bash
ls ~/.local/bin
```

この実行結果内に`pip`や`pip3`等の表示があれば，以下のコマンドでパスを通します．
なかった場合，`which pip`でpipが置かれているパスを確認し，`~/.local/bin`配下にpipを移動してください．

```bash
export PATH=$PATH:~/.local/bin
```

パスを通したら，pipコマンドが実行できるか確認します．
方法は，[pipがインストールされているかの確認](#pipがインストールされたかの確認)と同様です．

[TOP に戻る](#目次)

[HOME に戻る](../README.md)

## makeのインストール
makeは主として，C言語やC++などコンパイル型のプログラミング言語で記述されたプログラムを容易にビルドするためのツールです．
本システムでも，コマンドラインでの実行の簡略化のためMakefileを配置し使用しています．

### Linux環境の場合
aptを利用してインストールする場合を説明します．

#### aptをupdate

```bash
sudo apt update
```

#### makeをインストール

```bash
sudo apt install -y make
```

#### makeがインストールされたかの確認
次のコマンドを実行し，makeのバージョン情報が出ればインストール完了です．

```bash
make -version
```

### Windows環境の場合
公式サイトからインストールします．
[こちら](https://www.kkaneko.jp/tools/win/make.html)を参考にしてください．
(参考：福山大学 工学部情報工学科 金子邦彦教授ページ)

[TOP に戻る](#目次)

[HOME に戻る](../README.md)

## dockerのインストール


### Linux環境の場合
aptを利用してインストールする場合を説明します．

#### aptレポジトリを使ってDockerをインストールする

```bash
sudo apt update
sudo apt install ca-certificates curl gnupg lsb-release
```

#### DockerのGPGの鍵をaptに登録
これで，aptによる，インストールしたDockerパッケージの検証が可能になります．

```bash
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
```

curlコマンドで，Ubuntuで利用できるDockerのGPG鍵をダウンロードし，標準のOpenGPGエンコーディングに変換，aptのキーリングディレクトリに保存します．  
chmodは，aptが確実に検出できる様，キーリングファイルに対して権限を設定するコマンドです．

#### パッケージ情報ダウンロード
先ほど追加したGPG鍵を用いて認証が行われ，リポジトリが新たなパッケージリストとして`apt /etc/apt/sources.list.d directory.`に追加されます．

```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

#### 3つの最新版のDocker Community Edition（CE）をインストール
`docker-ce`：Docker Engineのデーモン
`docker-ce-cli`：操作することになるDocker CLI
`containerd.io`：コンテナの起動と実行に利用するコンテナランタイム/ソフトウェア（containerd）

```bash
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io
```

#### Docker Engineの動作を確認する
コンテナを起動し，正常に動作することを確認します．

```bash
sudo docker run hello-world
```

#### UbuntuでのDocker Engineの権限設定
通常，`docker`CLIコマンドの実行にroot権限が必要ですが，sudoを記述せずにdockerコマンドを実行する権限が得られます．  

まず`docker`グループが存在しているかを確認します．

```bash
sudo groupadd docker
```

次に，自分をグループに追加します．

```bash
sudo usermod -aG docker $USER
```

過去に`sudo`で`docker`コマンドを実行したことがある場合は，`~/.docker`ディレクトリの権限を編集する必要があります．  
これにより，自分のユーザーアカウントを使ったディレクトリ内でのファイルの読み取りと書き込みが許可されます．

```bash
sudo chown $USER:$USER /home/$USER/.docker -R
sudo chmod g+rwx $HOME/.docker -R
```

以上のコマンドの結果,   
`chown: '/home/$USER/.docker' にアクセスできません: そのようなファイルやディレクトリはありません`  
とエラーが出た場合は, 次を試してください.

```bash
sudo gpasswd -a $USER docker
```

として, 現行ユーザをdockerグループに所属させたのち,

```bash
sudo systemctl restart docker
```

としてdockerデーモンを再起動, その後再ログインするとよいです． 

システムから一度ログアウトし，再度ログインして新規グループメンバーシップを有効にします．  
その後，`sudo`を使わずに`docker`コマンドを実行してみましょう．

```bash
docker run hello-world
```

#### UbuntuにDocker Composeを追加する
Docker Composeは，複数のコンテナを使用する開発作業を簡易化してくれる，Dockerの人気ツールです．

```bash
sudo apt update
sudo apt install docker-compose docker-compose-plugin
```

### Windows/Linux GUI環境の場合
Docker Desktopをインストールします．
[公式サイト](https://www.docker.com/products/docker-desktop/)より，インストールしてください．

[TOP に戻る](#目次)

[HOME に戻る](../README.md)
