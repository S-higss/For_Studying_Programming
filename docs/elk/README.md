# Elastic Stackの導入

## 目次
- [Elastic Stackとは](#elastic-stackとは)
- [Elastic Stackの構築](#elastic-stackの構築)
    - [javaのインストール](#javaのインストール)
    - [Elasticsearchのインストール](#elasticsearchのインストール)
    - [Kibanaのインストール](#kibanaのインストール)
    - [Kibana-Elasticsearch接続確認](#kibana-elasticsearch接続確認)
    - [Logstashのインストール](#logstashのインストール)
    - [Beatsのインストール](#beatsのインストール)
- [ログ分析に向けて](#ログ分析に向けて)
    - [logstash.confの設定](#logstashconfの設定)
    - [inputプラグインの設定](#inputプラグインの設定)

## Elastic Stackとは
OSS(Open-source Software)ベースの以下プロダクト群をElasticStackと呼びます(以前はELKと呼んでいた)．  
- Elasticsearch：データの保存・検索・分析
- Kibana：データの可視化，Elasticstackの設定・管理GUI
- Logstash：データ入力・変換，Elasticsearchへの出力
- Beats：各種データ収集，Logstash，Elasticsearchへのデータ出力

関係性を一枚のイメージにまとめた図が以下の通りです．
![Elastic-Stack関係性](./img/elasticstacks-960x538.webp)
Elastic Stackの役割は，Syslogサーバーに保存されているログファイルを取得してLogstashでパース，Elasticsearchに取り込み，Kibanaで可視化したり，csvファイルに出力させてSQLサーバーに取りこむことです．

詳しくは[Elastic](https://www.elastic.co/jp/)のサイトへ．

[TOP に戻る](#目次)

[HOME に戻る](../README.md)


## Elastic Stackの構築
以下にElastic Stackの構築法を記します．  
但し，Windows環境であることに注意してください．

### javaのインストール
LogstashやElasticsearchのインストールに必要であるjavaをインストールします．  
詳しくは[環境構築](../env/README.md#javaのインストール)を確認してください．

### Elasticsearchのインストール
zipファイルを[公式サイト](https://www.elastic.co/jp/downloads/elasticsearch)よりダウンロードします．  
その後解凍し，任意の場所へ展開します．

展開したファイル内で`bin`配下にある`elasticsearch.bat`を実行するとプログラムが動作し，Elasticsearchが立ち上がります．  
確認としてコマンドプロンプト上で
```bash
curl localhost:9200
```
を入力し，JSON形式でレスポンスが返ってくれば完了です．  

但し，筆者の端末上では
```bash
curl: (52) Empty reply from server
```
とエラーが吐き出されていました．  
恐らく暗号化されていない平文のHTTPトラフィックが受信され，接続が閉じられたことが原因と思われます．  
この解決方法としては，初回実行後`./config/elasticsearch.yml`内に記述されている`xpack.security.enabled`の値を`false`とすることです．  
このようにすることでJSON形式でレスポンスが返ってくるはずです．


[TOP に戻る](#目次)

[HOME に戻る](../README.md)

### Kibanaのインストール
Kibanaのインストール手順もElasticsearchのインストールとほぼ同様の手順で行うことができます．  
zipファイルを[公式サイト](https://www.elastic.co/jp/downloads/kibana)よりダウンロードし，解凍・展開します． 

展開したファイル内で`bin`配下にある`kibana.bat`を実行すると起動します．
その後ブラウザで`http://localhost:5601`に接続し，GUIが表示されれば完了です．

### Kibana-Elasticsearch接続確認
KibanaからElasticsearchに接続できているかの確認を行うことができます．  
先ほどブラウザで開いたKibanaの左側にあるサイドバーに`Dev Tools`があるので，そこに移動します．  
するとコンソール画面が出てくるため，そこで以下の入力を行った後に再生ボタンを押下します．  
```bash
GET /
```

先ほどのJSON形式のレスポンスが右画面に出力されれば，Kibana→Elasticsearchの接続も完了です．

[TOP に戻る](#目次)

[HOME に戻る](../README.md)

### Logstashのインストール
Logstashのインストール手順もほぼ同様の手順で行うことができます．  
zipファイルを[公式サイト](https://www.elastic.co/jp/downloads/logstash)よりダウンロードし，解凍・展開します．  

#### Logstash起動前の設定項目
`bin/logstash.bat`の実行前に，`logstash-8.10.2`配下に`logstash.conf`を作成する必要があります．  
まずは動作確認用に次のコードを`logstash.conf`に記述します．  
```bash
# 標準入力を受け付ける
input {
  stdin { }
}
# 標準出力を行う
output {
  stdout { codec => rubydebug }
}
```

#### Logstashの起動・動作確認
`bin`配下にある`logstash.bat`を実行して，Logstashを起動します．  
この際，`logstash-8.10.2`配下でコマンドプロンプトを起動し，次のコマンドで実行してください．
```bash
bin\logstash.bat -f logstash.conf
```
`logstash.conf`にタイプミス等なければ，実行結果に`The stdin plugin is now waiting for input:`が出力されます．  
コマンドプロンプトに任意の文字列を打ち込むと，そのまま返り値として出力されるはずです．  

実行例
```bash
# 入力
hello world
# 出力
{
    "@timestamp" => 2023-10-02T10:35:30.889064200Z,
          "host" => {
        "hostname" => "DESKTOP-01NBJ48"
    },
         "event" => {
        "original" => "hello world\r"
    },
       "message" => "hello world\r",
      "@version" => "1"
}
```

[TOP に戻る](#目次)

[HOME に戻る](../README.md)

### Beatsのインストール
Beatsのインストールは，インストール時のトラブルの際にBeatsに問題があるのかを切り分けるのが難しいため，Elastic Stackが正しく起動できた後に行います．  
今回はMetricbeatのインストール方法を例に挙げて紹介します．  

Beatsのインストール手順もほぼ同様の手順で行うことができます．  
zipファイルを[公式サイト](https://www.elastic.co/jp/downloads/beats/metricbeat)よりダウンロードし，解凍・展開します．  
最後に，Admin権限でPowerShellを起動し，`metricbeat-8.10.2-windows-x86_64`配下で次のコマンドを入力します．
```bash
.\install-service-metricbeat.ps1
```
但し，この実行の際に，
```bash
.\install-service-metricbeat.ps1 : このシステムではスクリプトの実行が無効になっているため、ファイル C:\metricbeat-8.10.
2-windows-x86_64\install-service-metricbeat.ps1 を読み込むことができません。詳細については、「about_Execution_Policies
」(https://go.microsoft.com/fwlink/?LinkID=135170) を参照してください。
発生場所 行:1 文字:1
+ .\install-service-metricbeat.ps1
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : セキュリティ エラー: (: ) []、PSSecurityException
    + FullyQualifiedErrorId : UnauthorizedAccess
```
とエラーが出る場合があります．  
この際は，以下のコードでセキュリティポリシーを変更してから実行してください．
```bash
Set-ExecutionPolicy Unrestricted -Scope Process
```
これにより，インターネットからダウンロードしたファイルを実行する場合は警告が表示されるものの実行は可能になります．  

実行した後は
```bash
Set-ExecutionPolicy Restricted -Scope Process
```
で元に戻しておきましょう．

#### Metricbeatのセットアップ
Metricbeatは基本的にインストールするだけでプロセスごとのCPU 使用率・メモリ使用率を収集できます．
---  工事中   ---


[TOP に戻る](#目次)

[HOME に戻る](../README.md)

## ログ分析に向けて
以下，Logstashを用いてデータ取得・加工し，Elasticsearchへ送付する方法を記します．

### logstash.confの設定
logstash.confはinput、filter、outputの3つに分かれています．動作確認時に少し記載しましたが，この章では本格的にlogstash.confを記載します．  
logstash.confの記載を変更する場合，念のためLogstashサービスを停止しておきましょう．

#### input
inputはログをどこから取得するか決める部分です．  
Logstashサービス再開時の挙動を指定することも可能です．

#### filter
filterはログをどのように加工・整形するかを決める部分です．

#### output
outputはログをどこに送るのかを指定する部分です．  
Elasticsearchへのデータ送付以外にもCSV形式など指定した拡張子でデータを出力することも可能です．

### inputプラグインの設定
input部分では情報の取得元ごとにプラグインが提供されています．  
今回はファイルを取得するため，fileプラグインを使います．
利用できるプラグインの種類は[公式サイト](https://www.elastic.co/guide/en/logstash/5.4/input-plugins.html)で確認できます．  

inputプラグインの記載例
```bash
input{
    file{
        path => "/フォルダのフルパス/logs/**.log"
    }
}
```
logstash.confの記載はJSON形式で行います．  
fileプラグインではpathが必須項目にあたり，`path => file's_path`のように指定します．  
パスの指定には正規表現を利用できますが，フルパスで記載する必要があります．

#### ファイルの読み込み位置を指定する
デフォルトの設定では，起動した後に更新された分だけファイルを読み取る設定になっているため，ファイルの読み込み位置を指定する必要があります．

どこまでファイルを読み取ったかは，Logstashが自動で`sincedb`というファイルに記録しています．  
設定を変更することで`sincedb`ファイルに記録されている履歴の次から情報を取得できます．  
ファイルの読み込み位置は`start_position`を用いて設定します．

`start_position`の設定
```bash
# Logstash起動後に追加されたログのみ取り込む場合（デフォルト）
start_position => "end"

# Logstashが停止後に追加されたログも取り込む場合
start_position => "beginning"
```

`start_position`を指定した`logsatsh.conf`
```bash
input{
    file{
        path => "/フォルダのフルパス/logs/**.log"
        start_position => "beginning"
    }
}
```

[TOP に戻る](#目次)

[HOME に戻る](../README.md)