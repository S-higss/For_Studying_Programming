# WSLの導入

WSLに関連するトラブルシューティングをまとめています．  

## 目次

- [WSLとは](#wslとは)
  - [提供されるディストリビューション](#提供されるディストリビューション)
- [インストール方法](#インストール方法)
- [使い方](#使い方)
  - [インストール可能なディストリビューションの一覧を表示](#インストール可能なディストリビューションの一覧を表示)
  - [ディストリビューションをインストールする](#ディストリビューションをインストールする)
  - [インストール済みのディストリビューションの一覧を表示する](#インストール済みのディストリビューションの一覧を表示する)
  - [インストール済みのディストリビューションを起動する](#インストール済みのディストリビューションを起動する)
  - [インストール済みのディストリビューションをアンインストールする](#インストール済みのディストリビューションをアンインストールする)
  - [既定のディストリビューションを変更する](#既定のディストリビューションを変更する)
  - [特定or全てのディストリビューションをshutdownする](#特定or全てのディストリビューションをshutdownする)
- [WSLトラブルシューティング](./trouble_shoot.md)

[HOME に戻る](../README.md)

## WSLとは

Windows Subsystem for Linuxの略で，Windows上でUbuntu等のLinuxディストリビューションを実行する機能です．  
2017年10月にWSL1が，2019年2月にWSL2が公開されました．  
WSL1はLinux自体のカーネルを動かすものではなく，Linux互換のシステムコールを提供するものでしたが，  
WSL2からはLinux自体のカーネルを動作させることで，互換性が向上しました．  

### 提供されるディストリビューション

- Ubuntu
- openSUSE
- Debian
- OracleLinux
- Kali Linux

※以下はサポート対象外

- Red Hat Enterprise Linux
- CentOS
- Rockey Linux
- AlmaLinux

[目次 に戻る](#目次)

[HOME に戻る](../README.md)

## インストール方法

Windows 10 バージョン 2004 ビルド 19041以降の場合はPowerShellを管理者権限で起動し，以下を実行することでインストール可能です．

```bash
wsl --install
```

[目次 に戻る](#目次)

[HOME に戻る](../README.md)

## 使い方

### インストール可能なディストリビューションの一覧を表示

オプションは`--list --online`もしくは`-l -o`．

```bash
wsl --list --online
# もしくは
wsl -l -o
```

### ディストリビューションをインストールする

オプションは`--install <distribution_name>`．

```bash
wsl --install Ubuntu-22.04
```

### インストール済みのディストリビューションの一覧を表示する

オプションは`--list`もしくは`-l`．

```bash
wsl --list
# もしくは
wsl -l
```

このオプションに`--verpose`もしくは`-v`オプションを追加することで詳細を表示できます．

```bash
wsl -l -v
```

### インストール済みのディストリビューションを起動する

オプションは`--distribution`もしくは`-d`．

```bash
wsl --distribution Ubuntu-22.04
# もしくは
wsl -d Ubuntu-22.04
```

### インストール済みのディストリビューションをアンインストールする

オプションは`--unregister`．

```bash
wsl --unregister Ubuntu-22.04
```

### 既定のディストリビューションを変更する

オプションは`--set-default`もしくは`-s`．

```bash
wsl --set-default Ubuntu-22.04
# もしくは
wsl -s Ubuntu-22.04
```

### 特定or全てのディストリビューションをshutdownする

全てのディストリビューションをshutdownするオプションは`--shutdown`，
特定のディストリビューションをshutdownするオプションは`--terminate`もしくは`-t`．

```bash
# 全てのディストリビューションをshutdown
wsl --shutdown

# 特定のディストリビューションをshutdown
wsl --terminate Ubuntu-22.04
## もしくは
wsl -t Ubuntu-22.04
```

[目次 に戻る](#目次)

[HOME に戻る](../README.md)

## WSLトラブルシューティング

[こちら](./trouble_shoot.md)

### 参考文献

[とほほのWSL入門](https://www.tohoho-web.com/ex/wsl.html)
