# 環境構築

## 目次
- [Pythonのインストール](#pythonのインストール)
- [pipのインストール](#pipのインストール)
- [makeのインストール](#makeのインストール)

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
