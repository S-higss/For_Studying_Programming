# Gitあれこれ

私が遭遇したGitに関連する様々なトラブルへの対応集です．


## 目次
- [featureブランチでもgit pushを可能にする](#featureブランチでもgit-pushを可能にする)
- [devcontainerからpushする](#devcontainerからpushする)
- [masterブランチのdbデータをfeatureブランチに上書き](#masterブランチのdbデータをfeatureブランチに上書き)
- [Authenticationのエラーによりpushできない](#authenticationのエラーによりpushできない)


[TOP に戻る](./README.md)  
[HOME に戻る](../README.md)


## featureブランチでも`git push`を可能にする
ローカルで複製したbranchをリモートリポジトリにpushする際の小ネタを紹介します．

以下のようにブランチをローカルで複製した際，
```bash
git checkout -b "feature/xx"
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
参考：https://blog.kinto-technologies.com/posts/2022-12-10-VSCodeDevContainer/  
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
ここで，SSHキーのpathは先ほど[公開/秘密鍵の作成](#公開秘密鍵の作成)で作成した秘密鍵のものを用いてください．  
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

    # masterブランチをマージし、コンフリクトを無視して上書き
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
ある時、developで`git pull`を行うと、
```bash
Encountered 2 files that should have been pointers, but weren't:
public/images/xxxx.png
public/images/yyyy.png
```
のように表示され、これをcommitしてpushしない限りbranch移動さえもできない状況となった。  
これらのファイルは自分が編集したわけではなく、共同編集者(他グループ)が編集したもので、  
これをpushしてしまうと彼らの修正が変更されてしまうことになる。これは避けたい。  
だが以下のどのコマンドを打ち込んでも解決はしなかった。  
- `git fetch origin`
- `git merge origin develop`
- `git reset --hard HEAD`
- `git reset --hard origin/develop`
- `git pull --rebase origin develop`
このような時は、以下のコマンドが役立つ。
```bash
git rm --cached -r .
git reset --hard
```
前者のコマンドは、リポジトリ内のすべてのファイルをインデックス（ステージングエリア）から削除するが、ワーキングディレクトリからは削除しない。  
これは、次のコミットでこれらのファイルがリポジトリから削除されることを意味する。  
その後強制的にリセットをかけることで元に戻る。