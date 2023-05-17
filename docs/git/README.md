# GitHubリモートレポジトリへpushするまで
以下，Linux環境での方法です．   
ssh接続する手順を紹介しています．

## 目次
- [Gitのインストール](#Gitのインストール)
- [ユーザ名・メールアドレスの設定](#ユーザ名・メールアドレスの設定)
- [公開・秘密鍵の作成](#公開・秘密鍵の作成)
- [makeのインストール](#makeのインストール)


## Gitのインストール 
まずコマンドライン上で

```bash
sudo apt-get update
sudo apt-get install git
```
を実行することによってGitがインストールされ,`git`コマンドが効くようになります．

```bash
git --version
```

でバージョンが表示されれば完了です．

## ユーザ名・メールアドレスの設定
まずGitHubアカウントを作成していることが大前提となるので，  
作成していない場合は[公式サイト](https://github.com/)にて，アカウントを作成してください．

GitHubにアクセスするために、`/.gitconfig`に登録済みユーザ名及びメールアドレスを設定します．

```bash
git config —global user.name <登録したユーザー名>
git config —global user.email <登録したメールアドレス>
```

どちらも設定出来たら，

```bash
git config --global --list
```

で設定情報を確認することができます．

## 公開・秘密鍵の作成
