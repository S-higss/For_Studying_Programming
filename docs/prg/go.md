# Go言語に関して

## Go言語の概要

Googleが開発したサーバサイド言語であり，軽量な並行処理を扱うことができる．  
簡単に書ける言語とよく言われる．  
(シンプルな文法，命名規則により書き方のブレが少ないと思われる．)  

### 並行処理と並列処理とは

並行処理と並列処理の違いの一つとして，「どの時間における」話なのか，という切り口がある．

- 並行処理  
ある時間の範囲において，複数のタスクを扱うこと．  
つまり，時間の範囲内で複数タスクをどのように終わらせるのかは指定されておらず，並列に処理している場合や代わる代わるの逐次処理を行っている場合もある．

- 並列処理  
ある時間の点において，複数のタスクを扱うこと．  
つまり，時間軸における1点にて，複数タスクを同時に実行する

### Go言語において重要な事柄

- ライブラリを使うためには`go install`を実行する
    従来は`go get`だったが，ver1.16から機能が分岐．  
    `go get`は編集・インストールする役割を持っていたが，go.modを編集するだけの機能となった．  
    `go install`でインストールするのはバイナリである．  
    ->軽量にインストールすることができる

- `go mod tidy`は`go get`を補完する役割  
    ->ソースコードを参照して整合性を見てくれる．  
    importしているが使用していないライブラリや，インストールしていないライブラリがあった際は，  
    go.modに一括追加・削除をすることで対処してくれる．

- `go build`とは  
    実行ファイルを作成するコマンドである．  
    例えば，main.goというファイルを作成する．  
    main.goを実行する際には，まずソースコードをコンパイルしてバイナリファイル(実行ファイル)を作成する必要がある．  
    これを行うのが`go build`である．

    この例では，

    ```bash
    go build main.go
    ```

    を実行することで，実行ファイルmainが作成される．  
    これを作成した後に，`main`とコマンドを入力することで晴れてmain.goが実行されることになる．

    つまり，main.goを実行する際には`go build main.go`と`main`の二つのコマンド入力が必要となるわけだが，  
    これを組み合わせたコマンドが存在し，それが

    ```bash
    go run main.go
    ```

    である．

- プロジェクト作成時  
    `go mod init <example>`により，`example`という名前のプロジェクトを作成することができる．  
    このコードにより，go.modファイルが作成される．  

    go.modファイルの例

    ```bash
    module example

    go 1.18
    ```

- go.mod  
道具箱のイメージ(package.jsonとほぼ同じ役割)  
モジュールの依存関係を管理するファイル

- go.sum  
整合性を保つ役割を担う  
モジュールの依存関係をハッシュ化して保存する．  
__一貫性と信頼性を担保__

- package  
コードの再利用と整理を担う  
goのコードファイルは必ず特定のパッケージに所属する．  
所属するディレクトリと同じ名前にするのが基本．  
よくある`fmt`はformatの略称(build-in関数)，`err`はerrorの略称というように，goでは略称を用いるのが基本．

- nilとnullの違い  
    goでは，nilは主にポインタ，スライス，チャネル，マップ，インターフェース，関数などの特定の方の変数が値を持たないことを示すために使用される．

    nullはGo言語では一般的ではないが，他の言語では通常，オブジェクトが存在しないことを示すために使用される．

- スライスとは  
    配列の要素を可変にすることができるデータ構造のこと．  
    大きな箱をイメージ．

    使用例

    ```bash
    // sliceの宣言
    var slice []int
    // append関数によりsliceに値の代入
    slice = append(slice, 1, 2, 3)
    // ターミナルへ出力
    fmt.Println(slice)

    //実行結果-->
    [1, 2, 3]

    // 以下の2行により上のコードを短縮して記述することも可能(初期化時に初期値を代入)
    slice := []int{1, 2, 3}
    fmt.Println(slice)
    ```

### その他もろもろ小ネタ

#### errors.New()とは  

errorsパッケージのNewという関数を使用したものであり，  
引数にエラーメッセージとなる文字列を受け取り，エラー型を返す．  
エラーメッセージをカスタマイズしたい場合は、事前にエラーメッセージとなる文字列を作っておく必要がある．

- メリット  
  - 既にエラー出力したい文字列が用意されている時には便利  
  - シンプルなエラーを生成したい時に便利

#### 関数名は必ずcapitalizeせよ

例えば以下のようなディレクトリ構成を考える。

```bash
sample
├──foo.go
└──bar.go
```

foo.go

```bash
package main

import "fmt"

func main(){
    fmt.Println(add(3,5))
}
```

bar.go

```bash
package main

func add(a int, b int) int {
    return a + b
}
```

この場合，単にmainパッケージのファイルを2つに分けただけであるため，

```bash
~\sample$ go build
~\sample$ .\sample
```

で実行可能であるが，このディレクトリ構成を

```bash
sample
├──foo.go
└──sub
   └── bar.go
```

のようにsubパッケージを適用して変更し，  

foo.go

```bash
package main

import (
    "fmt"
    "sample/sub"
)

func main(){
    fmt.Println(sub.add(3,5))
}
```

sub/bar.go

```bash
package sub

import "fmt"

func add(a int, b int) int {
    return a + b
}
```

のようにしたとしても，実は動かない．  
というのも外部パッケージとして外部から参照可能な関数の名前はcapitalizeされている必要があるためである．  
Goにおいてcapitalizeで関数を作成することで外部から可視状態にする(:Go用語でexported=エクスポートされた)ことができる一方でdecapitalizeすることで内部からのみ参照される関数とすることができる，  
従って，
foo.go

```bash
package main

import (
    "fmt"
    "sample/sub"
)

func main(){
    fmt.Println(sub.Add(3,5))
}
```

sub/bar.go

```bash
package sub

import "fmt"

func Add(a int, b int) int {
    return a + b
}
```

とする必要があるのである．
