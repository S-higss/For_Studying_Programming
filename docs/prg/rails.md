# Railsに関して

## 目次

- [デフォルトのrailsディレクトリ構成の概要](#デフォルトのrailsディレクトリ構成の概要)
- [railsコマンドの短縮形について](#railsコマンドの短縮形について)
- [railsコマンドの実行前に復元するには](#railsコマンドの実行前に復元するには)

[Programmingに関して に戻る](README.md)  
[HOME に戻る](../README.md)

## デフォルトのRailsディレクトリ構成の概要

Railsの以下のコマンドを実行し，環境構築が完了すると大量のファイルとディレクトリが作成されます．

```bash
rails _7.0.4.3_ new dir_example
```

Webアプリケーションのディレクトリをどう構成するかは本来自由なのですが，RailsのようなWebフレームワークではディレクトリとファイルの構造が標準化されています．ファイルやディレクトリの構造がすべてのRailsアプリで標準化されているおかげで，他の開発者の書いたRailsのコードが読みやすくなります．  
これはWebフレームワークを導入する大きなメリットです．

デフォルトのRailsディレクトリ構成の概要を以下に示します．

| __ディレクトリ__ | __用途__ |
| ---- | ---- |
| app/ | モデル，ビュー，コントローラ，ヘルパーなどを含む主要なアプリケーションコード |
| app/assets | アプリケーションで使うCSS，画像などのアセット |
| bin/ | バイナリ実行可能ファイル |
| config/ | アプリケーションの設定 |
| db/ | データベース関連のファイル |
| doc/ | マニュアルなど，アプリケーションのドキュメント |
| lib/ | ライブラリやモジュール置き場 |
| log/ | アプリケーションのログファイル |
| public/ | エラーページなど，直接公開するデータ |
| bin/rails | コード生成，コマンド実行，Webサーバー立ち上げなどで使うスクリプト |
| test/ | アプリケーションのテスト |
| tmp/ | 一時的なファイル |
| README.md | このアプリケーションの簡単な説明 |
| Gemfile | このアプリケーションで使うGemの定義ファイル（手動で追記） |
| Gemfile.lock | このアプリケーションで使われるGemの詳細ファイル（自動で生成） |
| config.ru | Rackミドルウェア用の設定ファイル |
| .gitignore | Gitに取り込みたくないファイルを指定するためのファイル |

[TOP に戻る](#目次)  
[Programmingに関して に戻る](README.md)  
[HOME に戻る](../README.md)

## railsコマンドの短縮形について

例えば，静的なページを扱うコントローラを`StaticPages`のように命名し，これを生成する場合，

```bash
rails generate controller StaticPages
```

というように，`generate`スクリプトで実行できます．  
この`rails generate`は，`rails g`という短縮形でも動作します．  
このような短縮形は，Railsにおいて他にも多数サポートしています．

以下に主なコマンドとその短縮形を示します．

| __完全なコマンド__ | __短縮形__ |
| ---- | ---- |
| `$ rails server` | `$ rails s` |
| `$ rails console` | `$ rails c` |
| `$ rails generate` | `$ rails g` |
| `$ rails test` | `$ rails t` |
| `$ bundle install` | `$ bundle` |

[TOP に戻る](#目次)  
[Programmingに関して に戻る](README.md)  
[HOME に戻る](../README.md)

## railsコマンドの実行前に復元するには

どれほど十分に気を付けていたとしても，Railsアプリケーションの開発中に何か失敗してしまうことはありえます．Railsにはそのような失敗をカバーする機能がいくつもあります．

一般的なシナリオの1つは，生成したコードを元に戻したい場合です．例えばコントローラを生成した後で，もっといいコントローラ名を思い付き，生成したコードを削除したくなった場合などです．Railsはコントローラ以外にも関連ファイルを大量に生成するので，生成されたコントローラファイルを削除するだけでは元に戻りません．自動生成されたコードを元に戻すためには，新規作成されたファイルを削除するだけではなく，既存のファイルに挿入されたコードも削除する必要があります．実際，`rails generate`を実行するとルーティングの`routes.rb`ファイルも自動的に変更されるので，これも元に戻さなくてはなりません．

このようなときは，「generate」（生成）と逆の意味を持つ，`rails destroy`というコマンドを実行することで元に戻せます．例えば次の2つのコマンドは，自動生成と，それに対応する取り消し処理の例です．

```bash
rails generate controller StaticPages home help
rails destroy  controller StaticPages home help
```

モデルの自動生成についても，同様の方法で元に戻すことができます．

```bash
rails generate model User name:string email:string
rails destroy model User
```

また，以下のようなマイグレーションの変更を元に戻す方法も用意されています．

```bash
rails db:migrate
```

元に戻したいときは，db:rollbackで1つ前の状態に戻します．

```bash
rails db:rollback
```

最初の状態に戻したいときは，VERSION=0オプションを使います．

```bash
rails db:migrate VERSION=0
```

上のコマンドのVERSION=0は，最初のシリアル番号，つまり最初に行ったマイグレーションに戻すという意味です．

[TOP に戻る](#目次)  
[Programmingに関して に戻る](README.md)  
[HOME に戻る](../README.md)
