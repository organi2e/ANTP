### なにこれ
------
プロセスを実行している端末間で時刻を同期させるツール  
グローバルのntpサーバに接続できないローカルネット内部で時刻を同期させる場合などに使お？  

### どう使うの
------
同期させたい端末全で```sudo ANTP```を実行  
自動実行させるなら *launchdaemon* とか併用しよ？

### なんか動かないんだけど
------
```log``` コマンドでログ見よ？  
```log stream --info --predicate 'subsystem == "ANTP"'```
