# Pythonの小ネタ集
Pythonのインストール方法は[環境構築](../env/README.md#pythonのインストール)を確認してください．

## 目次
- [リストの比較の実行時間](#リストの比較の実行時間)

### リストの比較の実行時間
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
