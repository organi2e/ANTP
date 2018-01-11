### なにこれ
------
プロセスを実行している端末間で時刻を同期させるツール  
グローバルのntpサーバに接続できないローカルネット内部で時刻を同期させる場合などに使お？  

### どう使うの
------
同期させたい全端末で管理者権限で実行しよ？  
```sudo ANTP```  
自動実行させるなら`launchdaemon`とか併用しよ？

### なんか動かないんだけど
------
```log``` コマンドでログ見よ？  
```log stream --info --predicate 'subsystem == "ANTP"'``` とかしよ？

### 同期させるグループを分けたいんだけど
------
プロセス名 = 構成するネットワーク名  
つまりプロセス名を変えて実行しよ？  
ログpredicateに使うsubsystem名も変わるので注意しよ？

### 時刻の基準となる端末を指定したいんだけど
------
辞書順で一番若いホスト名の端末が参照先になる  
つまり基準にしたい端末のホスト名をAとか若いものにしよ？  

### ホスト名変えずに指定したいんだけど
------
諦めて
