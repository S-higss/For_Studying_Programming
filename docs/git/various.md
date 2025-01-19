# Gitあれこれ

私が遭遇したGitに関連する様々なトラブルへの対応集です．

## 目次

- [Gitあれこれ](#gitあれこれ)
  - [目次](#目次)
  - [featureブランチでも`git push`を可能にする](#featureブランチでもgit-pushを可能にする)
    - [補足](#補足)
  - [devcontainerからpushする](#devcontainerからpushする)
  - [masterブランチのdbデータをfeatureブランチに上書き](#masterブランチのdbデータをfeatureブランチに上書き)
  - [Authenticationのエラーによりpushできない](#authenticationのエラーによりpushできない)
  - [developでpullすると自分の編集していないファイルが差分として出てくる](#developでpullすると自分の編集していないファイルが差分として出てくる)
  - [PRに際して多過ぎるcommitを一つにまとめる](#prに際して多過ぎるcommitを一つにまとめる)
  - [機密データをpushしてしまった](#機密データをpushしてしまった)
  - [機密データをpushしてしまっていた](#機密データをpushしてしまっていた)
  - [参考文献](#参考文献)

[TOP に戻る](./README.md)  
[HOME に戻る](../README.md)

## featureブランチでも`git push`を可能にする

ローカルで複製したbranchをリモートリポジトリにpushする際の小ネタを紹介します．

以下のようにブランチをローカルで複製した際，

```bash
git checkout -b feature/xx
or
git switch -c feature/xx
```

このブランチにて行った変更をリモートリポジトリにアップロードする際，

```bash
git push origin feature/xx
```

というようにブランチ指定してpushができますが，現在のブランチが`feature/xx`である場合は，

```bash
git push origin HEAD
```

で代用できます．  

masterでのpushは`git push`で事足りるのに，  
上の代用でもその後の`origin HEAD`を記述する必要があり手間に感じませんか．  
(私はこれしか方法を知らなかったため手間に感じました)．

そこで更に初めて行うpushを

```bash
git push -u origin HEAD
```

として，`-u`オプションをつけることで`feature`と`origin/feature`が紐づくことになり，  
以降のpushは

```bash
git push
```

のみの実行でremoteにアップロードができるようになります．

### 補足

`-u`オプションは，`--set-upstream`と同じであり，  
このオプションをつけることでlocalの現在のブランチの上流をorigin featureに規定したことになります．  
つまりこのコマンドによってoriginにfeatureブランチをpushし，localの上流がorigin featureに移るため，以後は`git push`のみでremoteへのアップロードが可能となるというわけです．

[目次 に戻る](#目次)

[TOP に戻る](./README.md)

[HOME に戻る](../README.md)

## devcontainerからpushする

VS CodeのRemote Container拡張を使って開発するとdevcontainer内部からgitを扱うこともできます．  
参考：[VSCode Dev Containerを使った開発環境構築](https://blog.kinto-technologies.com/posts/2022-12-10-VSCodeDevContainer/)  
WSLのLinux環境にて，devcontainerで開発しているときに`git push`すると，以下のようなエラーが吐き出されました．

```bash
$ git push origin HEAD
git@github.com: Permission denied (publickey).
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.
```

devcontainerには，`.gitconfig`が自動でコピーされていますが，  
GitHubにpushするのにSSHキーを使う場合，必要なSSHキーも共有する必要があります．  
これに関して，VSCode公式サイトの[Sharing git credentials](https://code.visualstudio.com/remote/advancedcontainers/sharing-git-credentials#_using-ssh-keys)で紹介されていますが，ハマったのでまとめておきます．

この節で行いたいことは，この通りです．

```bash
+--------------+     +-----------------+     +--------+
| devcontainer | --> | Host(ssh-agent) | --> | GitHub |
+--------------+     +-----------------+     +--------+
```

まず，

```bash
vi ~/.bashrc
```

を行い，末尾に以下を記述します．

```bash
eval "$(ssh-agent -s)"
if [ -z "$SSH_AUTH_SOCK" ]; then
   # Check for a currently running instance of the agent
   RUNNING_AGENT="`ps -ax | grep 'ssh-agent -s' | grep -v grep | wc -l | tr -d '[:space:]'`"
   if [ "$RUNNING_AGENT" = "0" ]; then
        # Launch a new instance of the agent
        ssh-agent -s &> $HOME/.ssh/ssh-agent
   fi
   eval `cat $HOME/.ssh/ssh-agent`
fi
eval `ssh-add $HOME/.ssh/id_rsa`
eval `ssh-add $HOME/.ssh/id_rsa > /dev/null 2>&1`
```

ここで，SSHキーのpathは先ほど[公開/秘密鍵の作成](./setup.md#公開秘密鍵の作成)で作成した秘密鍵のものを用いてください．  
その後，

```bash
source ~/.bashrc
```

で読み込みなおすと，devcontainer内でのpushが可能となります．

[目次 に戻る](#目次)

[TOP に戻る](./README.md)

[HOME に戻る](../README.md)

## masterブランチのdbデータをfeatureブランチに上書き

masterブランチにて定期的に更新されるデータベースデータ(dbデータ)を，  
`git pull`によりfeatureブランチにある古いdbデータへと上書きしようとすると，

```bash
> git pull origin master
From github.com:yourproject
 * branch            master       -> FETCH_HEAD
Auto-merging db/sample.db
CONFLICT (content): Merge conflict in db/sample.db
Encountered 1 file that should have been a pointer, but wasn't:
        db/sample.db
Automatic merge failed; fix conflicts and then commit the result.
```

のようになり，conflictが発生するため失敗します．  
この事象に対してmergeエディタなど使用してconflictの解消を行うことは可能ですが，  
私の環境下ではこれを行う際に.dbファイルの内容がgitのチェックサムに用いられるハッシュに置き換わってしまうため，  
いちいちgithubの該当プロジェクトのWebブラウザからdbファイルをダウンロードし置き換えるという操作をしていました．

これを解消する方法が見つかったので記します．  

- 手順
  1. featureブランチにチェックアウト
  2. コンフリクトを無視してmasterブランチをmergeして該当ファイルを上書き
  3. 変更のコミット

- コマンド

    ```bash
    # featureブランチにチェックアウト
    git checkout feature

    # masterブランチをマージし，コンフリクトを無視して上書き
    git merge -s ours master

    # masterブランチの内容をfeatureブランチに上書き
    git checkout master -- path/to/database

    # 変更をステージング
    git add path/to/database

    # 変更をコミット
    git commit -m "Merged master into feature, overwriting database with master's version"
    ```

    ここで，一度conflictが発生してしまっている環境下では，上記操作の前に

    ```bash
    git merge --abort
    ```

    により一度現行のmergeを中止する必要があります．

[目次 に戻る](#目次)

[TOP に戻る](./README.md)

[HOME に戻る](../README.md)

## Authenticationのエラーによりpushできない

`git push`を実行しようとした際，

```bash
fatal: Authentication failed for ~~
```

とのエラーによりpushができないことがあります．

このような際は

```bash
git remote -v
git remote set-url origin git@github.com:USERNAME/YOURREPOSITORY.git
```

により解決可能です．

[目次 に戻る](#目次)

[TOP に戻る](./README.md)

[HOME に戻る](../README.md)

## developでpullすると自分の編集していないファイルが差分として出てくる

ある時，developで`git pull`を行うと，

```bash
Encountered 2 files that should have been pointers, but weren't:
public/images/xxxx.png
public/images/yyyy.png
```

のように表示され，これをcommitしてpushしない限りbranch移動さえもできない状況となった．  
これらのファイルは自分が編集したわけではなく，共同編集者(他グループ)が編集したもので，  
これをpushしてしまうと彼らの修正が変更されてしまうことになる．これは避けたい．  
だが以下のどのコマンドを打ち込んでも解決はしなかった．  

- `git fetch origin`
- `git merge origin develop`
- `git reset --hard HEAD`
- `git reset --hard origin/develop`
- `git pull --rebase origin develop`  

このような時は，以下のコマンドが役立つ．

```bash
git rm --cached -r .
git reset --hard
```

前者のコマンドは，リポジトリ内のすべてのファイルをインデックス（ステージングエリア）から削除するが，ワーキングディレクトリからは削除しない．  
これは，次のコミットでこれらのファイルがリポジトリから削除されることを意味する．  
その後強制的にリセットをかけることで元に戻る．

[目次 に戻る](#目次)

[TOP に戻る](./README.md)

[HOME に戻る](../README.md)

## PRに際して多過ぎるcommitを一つにまとめる

!! 以下の方法は他の開発者に影響を与える可能性があるため，merge元のブランチに共同開発者がいる場合は事前に確認すること !!
複数人で一つのprojectに対して作業をしているとき，PRに関わるcommitが多過ぎると，  
見た目が汚い上にreviewerも困る．  
そこで，複数のcommitを1つにまとめよう．ということで検索をかけた方はわかると思うが，  
ネット上には

```bash
git rebase -i HEAD~2 // 2つ前までのcommitをまとめる
```

で解決！！  
...とあるが，上記のように大規模な開発となるとそうはいかない．  
というのも複数ブランチを行き来して作業したり，  
PRを出すまでの間にも他のPRによってdevelopブランチへと変更がマージされたりと，  
`git log --oneline`をしてみると，自分の変更以外のものも紛れ込む．  
`git reflog`をしても他ブランチの作業履歴などが反映されるために，  
ただ単純に`git rebase -i HEAD~x`とするわけにはいかないのだ．  

そこで，以下の方法が有効である．  
あなたの作業ブランチがbranch-Aであり，developブランチへとmergeしたい場合を考える．  
このとき，まず

```bash
git merge-base branch-A develop
```

を実行することで，  
developブランチからbranch-Aが作成されたとすると，このコマンドで共通の親コミットIDが得られる．  
この親コミットIDをabcxyzとすると，  

```bash
git log --oneline abcxyz..branch-A
```

で自分のcommitだけが表示されるのである．  

そして，ブランチ分岐から現在のHEADまでの自分のcommitだけを取得してrebaseするには，

```bash
git rebase -i abcxyz
```

である．  

その後の操作はネットに沢山転がっているので詳しくは述べないが，以下の手順の通りである．  

1. コミットを一つにまとめる  
   エディタが開いたら，最初のコミットを pick のままにし，残りのコミットをすべて squash または s に変更する．

   ```bash
   pick <最初のコミットID> 最初のコミットメッセージ
   squash <2番目のコミットID> 2番目のコミットメッセージ
   squash <3番目のコミットID> 3番目のコミットメッセージ
   ...
   squash <最後のコミットID> 最後のコミットメッセージ
   ```

2. コミットメッセージを編集する
   すべてのコミットを一つにまとめた後，新しいコミットメッセージを編集する画面が表示されます．適切なメッセージに編集して保存する．  
   その前にconflictが起これば都度修正しつつ，

   ```bash
   git rebase --continue
   ```

   でrebaseを続ける．  
   途中の状況を知りたければ，

   ```bash
   git rebase --edit-todo
   ```

   により確認できる．  
   もちろん，この時開いたeditorは:q!等で変に変更して保存しないように．

3. リベースの完了
   リベースが完了したら，晴れてlocalのbranch-Aは一つのコミットにまとめられる．

4. リモートブランチを強制プッシュ
   もちろん今の状態はlocalを変更したに過ぎないので，remoteへ変更を反映させるために，強制プッシュを行う．

   ```bash
   git push origin branch-A --force
   # or
   git push -f origin branch-A
   ```

以上が終われば，晴れてPRのcommitが1つにまとまり，超スッキリ．

以下余談だが，上記作業をPR出す直前にのみ行なった場合，  
developとの競合状態によっては，とてつもない量のconflict解消作業が発生する．  
これを避けるために，developが変更されていそうであれば都度

```bash
git pull --rebase origin develop
```

により最新のdevelopを取り込むのが最良である．  
(もちろん自分のみが作業を行なっているブランチであることが前提)

[目次 に戻る](#目次)

[TOP に戻る](./README.md)

[HOME に戻る](../README.md)

## 機密データをpushしてしまった

commitに機密データを含めたままpushしてしまったことがある．  
公開設定がprivateで機密データを含めたcommitがその1つだけであれば傷が浅い．  
public設定ならば直ちに対処が必要である．  

当該Tipsは直前のcommitだけを取り消したい場合に有効であり，過去のcommitまで遡って打ち消したい場合は[次のTips](#機密データをpushしてしまっていた)を推奨する．

対処法を以下に記す．  
結論としては「`reset`コマンドを用いる」である．  
"commitを取り消したい"と検索をかけると`revert`を用いればよいという情報が出てくるが，  
機密データを完全に履歴から削除したいならば避けなければならない．  
なぜなら`revert`は対象commitを打ち消すようなcommitを新たに追加するためであり，対象commitは履歴に残り続け，参照できてしまうためである．  
対して`reset`はcommit履歴を書き換えて対象commitがなかったことにできる，

まず以下のコマンドで対象commitのIDを確認する．  
`--graph`オプションは無くともよいが，あるとmerge commitの親1と親2が区別できて見やすい．  

```bash
git log --graph --oneline

# 実行結果
*   000a111 (HEAD -> develop, origin/develop, origin/HEAD) Merge branch 'develop' of https[:]//github.com/sample into develop
|\
| * 111bc2d [feature]sample commit
| * 22de333 [update]sample function
```

このとき，ID`000a111`により機密データがcommitされてしまったとすると，  
次のコマンドで履歴をID`111bc2d`にまで戻す必要がある．  

```bash
git reset --hard 111bc2d
```

再び`git log`コマンドで履歴を確認すると，確かに履歴が戻されていることが確認できる．  
最後に，現在のローカルリポジトリの状態をリモートリポジトリに上書きを行う．  
***注意*** 他の開発者がこのブランチで作業している場合conflictが発生する可能性があるため要確認．  

```bash
git push origin develop --force
```

[目次 に戻る](#目次)

[TOP に戻る](./README.md)

[HOME に戻る](../README.md)

## 機密データをpushしてしまっていた

過去にパスワードを含むファイルをgithubに保存してしまっていたことがあった．  
privateに設定していたため何とかなったが，これがpublicであると洒落にならない．  
とは言ってもこれを見ているということはprivateであれpublicであれ一刻も早く消したいということであろう．  

そこで対処法を以下に記す．  
結論としては「`filter-branch`コマンドを用いる」である．  

```bash
git filter-branch --index-filter 'git rm --cached --ignore-unmatch <filename>' HEAD
```

これは．大量のコミットの書き換えを機械的に行うオプションである．  
`filter-branch`自体がshell scriptで記述されており，`--index-filter`オプションを用いることで全てのcommitを精査して対象ファイルを削除する．  
これを用いることで，githubのhistoryからも削除されることになり，完全に抹消が可能となる．  

上記操作後は大量のコミット履歴においてリモートと差異がでるため，`push --force`が必須となる．  
したがって，**これがチームでの開発であるならば注意が必要である**．  

### 注意

このコマンドは大昔から存在し，

- 大規模なリポジトリに対しては遅くなることがある
- 設定や使用方法が複雑で，誤った操作を行いやすい
- 多くの問題を引き起こす可能性がある

という問題点があるため，`filter-repo`をインストールして使用することが推奨されている．  
詳細は[こちら](https://qiita.com/propella/items/7b149c8e979b0d9fe416)を参照してください．  

### 参考文献

- [【git rebase -i】したときのコマンドをすべて試してみた(p, r, e,s ,f ,x ,d)](https://qiita.com/ykhirao/items/e9f723a553d4eb050817)  
- [最新のdevelopの取り込みはgit pull --rebase派](https://sakaishun.com/2022/09/23/git-pull-rebase/)  
- [今さらながらgit pull –rebase origin developについて調べた](https://sakaishun.com/2022/09/23/git-pull-rebase/)
- [git最強のオプション filter-branch](https://qiita.com/Spring_MT/items/f60c391b5dbf569a1d12)
- [git-filter-repo](https://qiita.com/propella/items/7b149c8e979b0d9fe416)

[目次 に戻る](#目次)

[TOP に戻る](./README.md)

[HOME に戻る](../README.md)
