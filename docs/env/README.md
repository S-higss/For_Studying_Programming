# 環境構築

## 目次
- [javaのインストール](#javaのインストール)
- [Pythonのインストール](#pythonのインストール)
- [pipのインストール](#pipのインストール)
- [makeのインストール](#makeのインストール)
- [dockerのインストール](#dockerのインストール)
- [MySQLのインストール](#mysqlのインストール)
- [Node.jsのインストール](#nodejsのインストール)
- [Ruby on Rails環境構築](#ruby-on-rails環境構築)

## javaのインストール
ここではOpen JDKを使用します．  
以下はJDK 21をWindowsでインストールする例ですが，他バージョンに更新されている場合は各自読み替えてください．

### OpenJDKのダウンロード
オラクルが提供するOpenJDKのバイナリを[JDK Builds From Oracle](http://jdk.java.net/)よりダウンロードします．  
サイトを開くと，`Ready for use: JDK 21, JavaFX 21, JMC8`とあるので，その内の`JDK 21`をクリックします．  
飛んだページより，`Builds`の`Windows/x64`の行にある`zip`をクリックするとダウンロードが開始されます．  
`Builds`の`Windows/x64`の行にある`(sha256)`をクリックするとハッシュ値が表示されるので，念のため以下をターミナル上で実行し，ダウンロードされたzipファイルとの整合性を確認しておきましょう．
```bash
certutil -hashfile ＜ファイルパス＞ sha256
```

### OpenJDKのインストール
ダウンロードしたzipファイルを解凍するとjdk-21というフォルダがあるため，任意の場所に展開してください．  
プログラムをコンパイル・実行する際に必要なプログラムはbinディレクトリ内に配置されています．  
OpenJDKのインストールはこれで完了です．

### PATHの設定及び環境変数JAVA_HOMEの設定
javaを用いたプログラムのコンパイルや実行するために必要なファイルが設置されたディレクトリへPATHを設定する方法を記します．今後バージョン変更があった場合や異なるJDKへ切り替えを容易にするために環境変数JAVA_HOMEの設定を行った上でPATHを設定します．

#### 環境変数JAVA_HOMEの設定
環境変数の画面を開き，`システム環境変数`の下にある`新規`ボタンを押し，現れたウィンドウで`変数名`に`JAVA_HOME`を，`変数値`に`C:\<先ほど展開した場所へのパス>\jdk-21`を入力してください．  
`システム環境変数`の中に`JAVA_HOME`が追加されていれば完了です．

#### PATHの設定
環境変数の画面にて，`システム環境変数`の中にある`Path`を選択し，`編集`をクリックすると，環境変数名の編集画面が表示されます．  
右上の新規をクリックし，`%JAVA_HOME%\bin`を入力し，OKを押してください．  
ターミナルを開き，
```bash
javac -version
```
と入力し，`javac 21`と表示されればjavaのインストールは完了です．  
もしエラーが出る場合はPATHの設定が誤っている可能性があるため，再度確認して下さい．

[TOP に戻る](#目次)

[HOME に戻る](../README.md)


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
[こちら](https://www.python.jp/install/windows/install.html)を参考にしてください.  
(参考：Python.jp プログラミング言語 Python情報サイト)

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
コマンドラインでの実行の簡略化のためMakefileを配置し使用できます．

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
注意：`https://download.docker.com/linux/ubuntu/gpg`に関して，debianなら`https://download.docker.com/linux/debian/gpg`等，各環境によって読み替えてください．  

curlコマンドで，Ubuntuで利用できるDockerのGPG鍵をダウンロードし，標準のOpenGPGエンコーディングに変換，aptのキーリングディレクトリに保存します．  
chmodは，aptが確実に検出できる様，キーリングファイルに対して権限を設定するコマンドです．

#### パッケージ情報ダウンロード
先ほど追加したGPG鍵を用いて認証が行われ，リポジトリが新たなパッケージリストとして`apt /etc/apt/sources.list.d directory.`に追加されます．

```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```
注意：上に同じく，ubuntuの部分を各環境によって読み替えてください．  

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
`chown: '/home/<ユーザ名>/.docker' にアクセスできません: そのようなファイルやディレクトリはありません`  
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


## MySQLのインストール
Oracleが開発・サポートするオープンソースのSQLリレーショナルデータベース管理システムです．  
データベースは，データを簡単に使用したり取得したりできるように，そのデータをまとめて構造化したものです．  
WordPressサイトの場合，「データ」は，ブログ投稿の内容，サイトに登録されているユーザーの情報，自動読み込みデータ，重要な設定・構成などを指します．  
MySQLは，そのデータを保存・管理する人気のあるシステムの一つにすぎませんが，WordPressサイトでは特に人気のあるデータベースソリューションです．  
共同設立者の娘の名前である「My」と，リレーショナルデータベースのデータにアクセスして管理できるStructured Query Languageの略称である「SQL」を組み合わせたものです．
リレーショナルデータベースシステムであるだけでなく，クライアントサーバーモデルも採用しています．

### Linux環境の場合
#### Ubuntuの場合
MuSQLサーバとクライアントツールのインストールを行います．
```bash
sudo apt-get update
sudo apt-get install mysql-server mysql-client
```
バージョン確認をして終了です．
```bash
mysql --version
```

#### Debianの場合
[こちら](https://ohllengeapplication.com/blog/index.php/2023/11/08/howtoinstallmysql8ondebian12/)を参照してください．

### Windows環境の場合
[こちら](https://qiita.com/aki_number16/items/bff7aab79fb8c9657b62)のサイトを参考に実行してください．

[TOP に戻る](#目次)

[HOME に戻る](../README.md)


## Node.jsのインストール
- Node.jsとは  
    ブラウザ上という制限された環境でしか動けなかったJavaScriptを，PythonやRubyのようにパソコン上で動かせるようにしてくれるアプリケーションであり，  
    JavaScript実行環境です．  
    WindowsにPythonをインストールすると「python.exe」ができるように，Node.jsをインストールすると「node.exe」ができます．

- npmとは  
    npmはNode.jsのパッケージ管理ツールです．  
    例：Pythonにおけるpip，Rubyにおけるgem(RubyGems)，Debianにおけるapt，MacにおけるHomebrew，Rustにおけるcargoなどなど．  
    たまにyarnというのが出てきますがほぼnpmと同じです．

    「パッケージ」というのはライブラリやフレームワークのことです．  
    つまりVueやReact, webpack, jQueryなどのことです．  

    Node.jsで使いたいライブラリがある場合，jsファイルをダウンロードしてきて
    ```bash
    <script src="xxx.js"></script>
    ```
    って書いて……のようにすることなく，npmを使ってインストールできます．

### Linux環境の場合
aptを利用してインストールする場合を説明します．

#### Linuxディストリビューションの公式パッケージでNode.jsとnpmを入れる

```bash
sudo apt update
sudo apt install nodejs npm
```

#### インストールされたかの確認
次のコマンドを実行し，nodeのバージョン情報が出ればインストール完了です．
```bash
sudo node -v 
```

#### 最新のNode.jsを入れる
次のコマンドを実行し，最新のNode.jsがインストールされます．
```bash
sudo npm install n -g
```

### Windows/macOS環境の場合
インストーラを用いてインストールします．  

#### インストーラのダウンロード
[公式サイト](https://nodejs.org/en/download/prebuilt-installer)から，インストーラをダウンロードします．  
__ここで注意__ : 公式サイトではLTSバージョンのものをダウンロードしてください．私の場合，CURRENTをダウンロードし，`npm`コマンドが使えませんでした．

- LTSとは  
    Long-term Supportの略で，長期の保守運用が約束されたバージョンです．
- CURRENTとは  
    最新版であるが，安定性を約束しないことで機能追加を盛り込んだバージョンです．

#### インストーラの実行
基本的にはデフォルトのまま進んでください．  
Tools for Native Modulesのチェックボックスも，ネイティブモジュール用のツールは必要なければチェックを入れなくてOKです．  

#### インストールの確認
コマンドプロンプトにて次のコマンドを実行し，バージョン情報が表示されればNode.jsのインストール完了です．
```bash
Node --version
```
最後に，npmコマンドを確認しておきましょう．
```bash
npm -v
```

[TOP に戻る](#目次)

[HOME に戻る](../README.md)


## Ruby on Rails環境構築
Ruby on Rails(略称"Rails")は，プログラミング言語"Ruby"で書かれたフリーかつオープンソースのWeb開発フレームワークです．

Rubyはオープンソースの動的なプログラミング言語で，シンプルさと高い生産性を備えています．   
エレガントな文法を持ち，自然に読み書きができます．

Railsは本格的なWebサービスを開発するツールとして急速に有名になり，海外ではGitHubやShopify，DisneyやApple，AirbnbやSoundCloud，イギリス政府などで採用され，ドイツの政府系ファンド（STF）もRuby/Railsを支援しています．

また日本国内でもCookpadやnote，freeeやマネーフォワード，YAMAPやCrowdWorks，QiitaやZenn，Game8やアカツキ，pixivやSTORES，駅すぱあとやスタディサプリ，自治体に導入されているつながる相談などで採用されています．Rubyを採用している上場企業は45社以上にのぼり，2021年にはRailsを使い続けるGitLabも約1.2兆円の時価総額で上場，2024年のRails求人数も右肩上がりとなっています．

Webサービス開発にはRails以外にも多くの選択肢がありますが，Railsのアプローチは豪快かつ強力で，個人開発から上場まで幅広い場面に使えます．初めてWebサービスを作る個人にとってはRailsの標準機能だけで開発でき，大成功したときも高い拡張性を兼ね備えています．また大企業がシングルページアプリケーション（SPA）やモバイルアプリと組み合わせて開発したい場面でも，Railsは素晴らしいバックエンドを提供できます．

__注意点__  
RailsとRubyとで対応バージョンがある程度決まっており，古いと上手くいきませんので気を付けて下さい．  
以下対応表になります．
| __Rails version__ | __Ruby version__ |
| ---- | ---- |
| Rails 7 | Ruby 2.7.0以降が必須 |
| Rails 6 | Ruby 2.5.0以降が必須 |
| Rails 5 | Ruby 2.2.2以降が必須 |

### Linux環境の場合
apt-getを利用してインストールする場合を説明します．
```bash
sudo apt-get update -y
sudo apt-get install ruby-full
```
でインストールできますが，最新版ではない可能性が高いです．  
バージョン指定してインストールを行いたい場合は以下の通りに実施してください．


#### 必要なツールのダウンロード
```bash
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install build-essential -y
sudo apt-get install -y libssl-dev libreadline-dev zlib1g-dev libffi-dev libyaml-dev
```

#### Rubyのインストール
```bash
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
exec $SHELL -l
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
```
Rubyのバージョン指定をしてインストールします(今回は3.2.4を指定)．
```bash
rbenv install 3.2.4
rbenv global 3.2.4
```
インストールされたか確認
```bash
ruby -v
```

#### SQLite3のインストール
apt-getを利用してSQLite3をインストールします．  
SQLite3は，MySQLと同じくオープンソースのデータベース管理システムであり，軽量であるのが特徴です．
```bash
sudo apt-get install libsqlite3-dev
```

#### Railsのインストール
gemを使用して，Railsのバージョン指定をしインストールします(今回は7.0.4.3を指定)．  
gemとは，gem形式にパッケージングされたRuby言語用の外部ライブラリを指します．
```bash
gem install rails -v "7.0.4.3"
```
インストールされたか確認
```bash
rails -v
```
Railsのインストール完了時に，以下のような表示がなされる場合があります．
```bash
A new release of RubyGems is available: 3.4.19 → 3.5.15!
Run `gem update --system 3.5.15` to update your installation.
```
この場合は素直に表示に従って，以下のコマンドを用いてgemのアップデートを行いましょう．
```bash
gem update --system 3.5.15
```

#### bundlerのインストール
こちらもgemを使用して，バージョン指定をしインストールします(今回は2.5.6を指定)．  
bundlerとは，gem同士の依存関係を管理するためのツールで，bundler自体もgemの一種です．  
bundlerを使うことで，依存関係にあるgemを一括インストールすることができます．
```bash
gem install bundler -v 2.5.6
```
インストールされたか確認
```bash
bundler -v
```

### Windows環境の場合
#### Rubyのインストール
まず，Rubyをインストールします．
1. [RubyInstaller](https://rubyinstaller.org/downloads/)のサイト内の「WITH DEVKIT」から好きなバージョンをクリックし，インストーラをダウンロードします．
   
2. インストーラを実行し，Rubyのインストールを行います．
   
3. インストール完了後，自動的にコマンドプロンプトが起動し，
    ```bash
    Which components shall be installed? If unsure press ENTER [1,3]
    ```
    と表示されるので，
    ```bash
    1,3
    ```
    を入力します．  
    全ての実行が完了すると，
    ```bash
    Which components shall be installed? If unsure press ENTER []
    ```
    と表示されるので，そのままEnterキーを押下します．

4. 以上でRubyをinstallする作業は完了となるので，最後に
    ```bash
    ruby -v
    ```
    でインストールを確認しておきます．

#### SQLite3のインストール
次に，SQLite3をインストールします．  
1. [SQLite3](https://sqlite.org/index.html)のサイトを開き，「Download」をクリックします．
   
2. 「Precompiled Binaries for Windows」の欄にある「sqlite-dll」というファイルをクリックしてダウンロードします．
   
3. ダウンロードが完了しましたらフォルダを開き，「sqlite3.dll」を「C:¥Ruby26-x64¥bin」へコピーします．
   
4. 先程のSQLite3 のダウンロードページに戻り，「sqlite-tools-win32-x86-3410100.zip」というファイルもダウンロードします．
   
5. ダウンロードが完了しましたらフォルダを開き，「sqlite3.exe」を先程同様「C:¥Ruby26-x64¥bin」へコピーします．
   
6. 以上でSQLite3のインストールは完了です．

#### Ruby on Railsのインストール
以降はLinuxの場合と同様となるので，[Railsのインストール](#Railsのインストール)以下を参考にしてください．

[TOP に戻る](#目次)

[HOME に戻る](../README.md)
