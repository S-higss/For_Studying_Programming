# Linuxトラブルシューティング

Linuxに関連するトラブルシューティングをまとめています．  

## 目次

- [aptが壊れた](#aptが壊れた)

[HOME に戻る](../README.md)

## aptが壊れた

何かのきっかけで`apt`が壊れてしまったことがありました．  

```bash
sample@ubuntu:~$ sudo apt update
Hit:1 http://security.ubuntu.com/ubuntu bionic-security InRelease
Hit:2 http://jp.archive.ubuntu.com/ubuntu bionic InRelease                         
Hit:3 http://jp.archive.ubuntu.com/ubuntu bionic-updates InRelease
Hit:4 http://jp.archive.ubuntu.com/ubuntu bionic-backports InRelease
Traceback (most recent call last):
  File "/usr/lib/cnf-update-db", line 8, in <module>
    from CommandNotFound.db.creator import DbCreator
ModuleNotFoundError: No module named 'CommandNotFound'
Reading package lists... Done
E: Problem executing scripts APT::Update::Post-Invoke-Success 'if /usr/bin/test -w /var/lib/command-not-found/ -a -e /usr/lib/cnf-update-db; then /usr/lib/cnf-update-db > /dev/null; fi'
E: Sub-process returned an error code
```

Errorから見るにCommandNotFoundが存在しないことが原因だと思われますが，

```bash
sudo apt-get purge command-not-found
sudo apt-get install command-not-found
```

などを行っても解決せずハマりました．  
このような際に有効な方法が`apt`のキャッシュの再構築です．  
方法は以下の通りです．  

```bash
sudo rm -rf /var/lib/apt/lists/*
sudo apt-get update
```

これにより`apt`のキャッシュが消去され，再構築されます．  
大抵の場合はこの方法で解決します．　　

[目次 に戻る](#目次)

[HOME に戻る](../README.md)
