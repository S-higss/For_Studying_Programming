# Pythonの小ネタ集
Pythonのインストール方法は[環境構築](../env/README.md#pythonのインストール)を確認してください．

## 目次
- [requirements.txtを使ってパッケージ一括インストール](#requirementstxtを使ってパッケージ一括インストール)
  - [pipの一括インストール](#pipの一括インストール)
  - [現在の環境の設定ファイルを書き出し](#現在の環境の設定ファイルを書き出し)
- [f文字列について](#f文字列について)
- [ソートについて](#ソートについて)
  - [数字のソート](#数字のソート)
  - [日付文字列のソート](#日付文字列のソート)
- [リストの比較の実行時間](#リストの比較の実行時間)
- [Excelファイルの読取](#excelファイルの読取)
  - [openpyxlを用いる場合](#openpyxlを用いる場合)
  - [pandasを用いる場合](#pandasを用いる場合)

[TOP に戻る](#目次)  
[Programmingに関して に戻る](README.md)  
[HOME に戻る](../README.md)


## requirements.txtを使ってパッケージ一括インストール
Pythonのパッケージ（ライブラリ）をpipで管理している場合，  
設定ファイル`requirements.txt`を使って指定のパッケージを指定のバージョンで一括インストールできます．

### pipの一括インストール
以下のコマンドにより設定ファイルrequirements.txtを読み込んでパッケージが一括でインストールされます．
```bash
pip install -r requirements.txt
```
設定ファイル名は任意ですが，`requirements.txt`という名前が使われることが多いです．

上記コマンド実行の際は`requirements.txt`はコマンドを実行するディレクトリに置いておきます．  
別ディレクトリにある場合は，パスを指定してください．

### 現在の環境の設定ファイルを書き出し
pip freezeコマンドで現在の環境にインストールされたパッケージとバージョンが`pip install -r`で使える設定ファイルの形式で出力されます．

つまり，`pip freeze`をリダイレクト`>`でファイルに出力することで，  
そのファイルを使って元の環境と同じバージョンのパッケージを別環境に一括でインストールできるというわけです．
```bash
pip freeze > requirements.txt
```
この`requirements.txt`を別の環境にコピーして一括インストールすることが可能です．


[TOP に戻る](#目次)  
[Programmingに関して に戻る](README.md)  
[HOME に戻る](../README.md)


## f文字列について
主にデバッグ用途で新規に実装されたf-stringsの機能の小ネタを紹介します．  
例えば，
```bash
x = 100
print(f"x={x})
=> x=100
```
のような`x`の値を`x=`の形で表示することを考えた時，新たなf-stringsでは以下の表現が可能です．
```bash
x=100
print(f"{x=})
=> x=100
```
こちらの機能はPython3.8より実装されています．

[TOP に戻る](#目次)  
[Programmingに関して に戻る](README.md)  
[HOME に戻る](../README.md)


## ソートについて
以下，数字および日付文字列のソートについて説明します．

### 数字のソート
まず数字のソートについて説明します．  
今，手元に`unsorted_numbers`というリストが以下のようにあり，これを`sorted_numbers`のように昇順に直すとします．
```bash
unsorted_numbers = [4, 2, 8, 12, 1, 0, 23, 24, 9, 6]
sorted_numbers = [0, 1, 2, 4, 6, 8, 9, 12, 23, 24]
```
もちろん数字の大小を比較して並び替えるという方法もよいですが，pythonには`sorted()`という便利な関数があります．  
これを用いると，
```bash
# 順番がバラバラの数字のリスト
unsorted_numbers = [4, 2, 8, 12, 1, 0, 23, 24, 9, 6]

# 昇順にソート
sorted_numbers = sorted(disconnected_numbers)

print(sorted_numbers)
# 実行結果 ==> [0, 1, 2, 4, 6, 8, 9, 12, 23, 24]
```
という短いコードで実行が可能です．  

今用いたのは数字のリストでしたが，これが数字文字列のリストの場合は少しコードが異なります．  
数字文字列のリストとは，以下のように数字が文字列として扱われたリストです．
```bash
unsorted_numbers = ['4', '2', '8', '12', '1', '0', '23', '24', '9', '6']
```
このような場合は，上記コードを実行しても，得られるリストは次のようなものとなってしまいます．
```bash
sorted_numbers = ['0', '1', '12', '2', '23', '24', '4', '6', '8', '9']
```
これは`sorted()`関数が文字列として比較するためで，デフォルトでは文字列として辞書順にソートされるからです．  
文字列としての辞書順でソートする場合，文字列の先頭の文字を比較して並べ替えが行われ，'12'が '2'，'23'，'24'などよりも大きいと見なされます．  
これは，`sorted()`関数の`key`パラメータを`int`と指定し，数値としてソートすることで避けられます(以下例)．
```bash
# 順番がバラバラの数字文字列のリスト
unsorted_numbers = ['4', '2', '8', '12', '1', '0', '23', '24', '9', '6']

# 昇順にソート
sorted_numbers = sorted(disconnected_numbers, key=int)

print(sorted_numbers)
# 実行結果 ==> ['0', '1', '2', '4', '6', '8', '9', '12', '23', '24']
```
ここで組み込み関数`sorted()`を用いましたが，これは元のリストは保たれる非破壊的処理となります．デフォルトは昇順ですが，降順にソートしたい場合は引数reverseをTrueとするとよいです(以下例)．
```bash
reverse_sorted = sorted(disconnected_numbers, reverse=True)
print(reverse_sorted)
# 実行結果 ==> [24, 23, 12, 9, 8, 6, 4, 2, 1, 0]
```
ソートの方法には，リスト型のメソッドである`sort()`も存在します．  
これは次項で紹介します．


### 日付文字列のソート
次に日付文字列のソートについて説明します．  
今，手元に`unsorted_dates`というリストが以下のようにあり，これを`sorted_dates`のように昇順に直すとします．
```bash
unsorted_dates = ["2023-01-15", "2023-01-17", "2023-01-20", "2023-01-22"]
sorted_dates = ['2023-01-15', '2023-01-17', '2023-01-20', '2023-01-22']
```
以下の手順を踏むことで，これを実行可能となります．
1. 日付文字列をdatetimeオブジェクトに変換します．
1. datetimeオブジェクトをソートします．
1. ソートされたdatetimeオブジェクトから日付文字列に戻します．

以上を踏まえると，
```bash
from datetime import datetime

# 不連続の日付の文字列リスト
unsorted_dates = ["2023-01-15", "2023-01-17", "2023-01-20", "2023-01-22"]

# 日付の文字列リストを日付オブジェクトに変換
date_objects = [datetime.strptime(date, "%Y-%m-%d") for date in dates]

# 日付オブジェクトのリストを昇順にソート
date_objects.sort()

# 昇順に直された日付の日付文字列リスト
sorted_dates = [date.strftime("%Y-%m-%d") for date in date_objects]

print(sorted_dates)

# 実行結果 ==> ['2023-01-15', '2023-01-17', '2023-01-20', '2023-01-22']
```
のようにできます．  
ここで，前項で触れたようにリスト型のメソッドである`sort()`を使用しているのですが，これは元のリスト自体を書き換える破壊的処理となります．これも`sorted()`同様にデフォルトは昇順なのですが，降順にソートしたい場合は引数reverseをTrueとすればよいです(以下例)，
```bash
# 日付オブジェクトのリストを降順にソート
date_objects.sort(reverse=True)
```


[TOP に戻る](#目次)  
[Programmingに関して に戻る](README.md)  
[HOME に戻る](../README.md)


## リストの比較の実行時間
今，手元に`list_old`というリストがあり，新しく`list_new`を得たとします．  
それぞれの要素の内容は以下の通りです．
```bash
list_old = ["a", "b", "c", "d", "e", "f", "g"]
list_new = ["a", "c", "d", "e", "f", "g", "h", "z"]
```
このとき，二つのリストを比較して，新しく追加された要素のみからなるリスト`new_elements = ["h", "z"]`を得ることを考えます．  

まず思いつく方法として，以下のコードがあると思います．
```bash
new_elements = []
for item in list_new:
    if item not in list_old:
        new_elements.append(item)

# もしくは以下
new_elements = [item for item in list_new if item not in list_old]
```
このようなコードは小規模なリストに対しては効率的なのですが，大規模なリストの場合には効率が低下する可能性があります．  
list_oldの要素数nに対してlist_newの各要素を順に比較する必要があり，実行時間がO(n^2)となってしまうためです．  
(実行時間がO(n^2)とは...一般的に入力サイズの増加に対して二次関数的に増加する．例：入力サイズ(n)が2倍となると実行時間は4倍に増加する．)  
(O(1)，O(n)やO(log n)などは効率的なアルゴリズムと言える．)

そのため大規模なリストを扱う際には，より効率的なアプローチをとる必要があります．  
解決策として，セット(集合)や辞書を使用することが挙げられます．セットや辞書を使用することで検索がO(1)の時間で行えます．  
(実行時間がO(1)とは...入力サイズに依存せず常に一定の時間で処理が完了する．)

以下は，セットを用いて先のコードと同様の動作を行うコード例です．
```bash
# リストをセットに変換
set_old = set(list_old)
set_new = set(list_new)

# list_newに含まれ、list_oldに含まれていない要素を取得
new_elements = list(set_new - set_old)
```
但し，setは[重複する要素をもたない，順序が簡単に予測出来ない要素の集まり](https://docs.python.org/3/library/stdtypes.html?highlight=set#set)であるので，  
これにより得られる`new_elements`は順序が保証されないことに注意が必要です．


[TOP に戻る](#目次)  
[Programmingに関して に戻る](README.md)  
[HOME に戻る](../README.md)


## Excelファイルの読取
Pythonでは，Excelファイルからデータを取得することを可能とするライブラリが提供されています．  
Excelファイルを操作するために便利なライブラリとして，`openpyxl`や`pandas`などがあります．  
どちらのライブラリも`pip install`コマンドでインストールが必要で，`pandas`を使うにしても`openpyxl`のインストールが必要となります．  
`pandas`は特にデータ解析と操作に優れており，データを効率的に処理するのに適しています．

### openpyxlを用いる場合
```bash
import openpyxl

# Excelファイルを読み込む
workbook = openpyxl.load_workbook('example.xlsx')

# シートを選択
sheet = workbook['Sheet1']

# セルの値を読み取る
cell_value = sheet['A1'].value

# 行や列をイテレートする
for row in sheet.iter_rows():
    for cell in row:
        print(cell.value)
```

### pandasを用いる場合
```bash
import pandas as pd

# Excelファイルを読み込む
df = pd.read_excel('example.xlsx')

# DataFrame(df)の内容を表示
print(df)

# DataFrameの総行数を取得・表示
row_count = len(df)
# => これは非常に大きなDataFrameに対しては遅い場合があるため，
#    row_count = df.shape[0]
#    がおすすめ．
#    (shape属性は行数と列数を含むタプルで，行数は0番目の要素に格納されている)
print(row_count)
```
DataFrameからのデータの取り出し方4選
1. 特定の列（カラム）の選択
    ```bash
    # 'column_name' 列を選択
    selected_column = df['column_name']
    ```
2. 特定の行（ロウ）の選択
    ```bash
    # インデックス番号 0 の行を選択
    selected_row = df.loc[0]
    ```
3. 特定のセルの値の取得
    ```bash
    # 行インデックス 0、列ラベル 'column_name' のセルの値を取得
    cell_value = df.at[0, 'column_name']
    ```
4. 条件に基づいたデータのフィルタリング
    ```bash
    # 'column_name' の値が 5 より大きい行を選択
    filtered_data = df[df['column_name'] > 5]
    ```

[TOP に戻る](#目次)  
[Programmingに関して に戻る](README.md)  
[HOME に戻る](../README.md)
