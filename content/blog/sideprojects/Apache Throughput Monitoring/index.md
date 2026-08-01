---
date: '2026-07-19T09:00:00+09:00'
draft: true
title: "Project#01【性能調査】Apache HTTPサーバにおいて、Throughputを制限する要因は何か"
authors:
    - name: Tseng 
      link: https://github.com/YukunTseng
tags:
    - Apache
    - Linux
    - JMeter
---
-------------------------------------------------------------------
Apache＋JMeter＋自作リソースログ収集スクリプトを用いて、CPU使用率、Apache Worker数、Linuxスケジューラの観点から検証し、調査結果を本記事にまとめてみました。
<!--more-->
-------------------------------------------------------------------

先に今回の検証結果をお伝えすると、CPU使用率だけではなく、
LinuxスケジューラによるCPU Resource Contentionも、Throughputを制限する要因であることが確認できました。
それでは、実際の検証内容と測定結果について説明していきます。

## 1. はじめに
Webサーバの性能を評価する際は、CPU使用率だけを見て、「CPUがボトルネック」と判断してしまうケースがあります。
しかし、本当にCPU使用率だけで性能限界を説明できるのかを判明したいので、
今回はJMeterと自作リソースログ収集スクリプトを用いて、
Apache HTTPサーバの性能限界を調査しました。

## 2. 検証目的
今回検証したいこと：

- CPU使用率とThroughputの関係
- Apache Worker数の変化
- Response Timeとの関係
- Linuxスケジューラの影響


## 3. システム構成
### 3.1. 構成図

![構成図](images/構成図.jpg "構成図")



### 3.2. 導入ソフトウェア
|項目|製品|
|---|---|
|ハイパーバイザー|VMware(R) Workstation Pro 26H1|
|OS|Rocky Linux 10.1|
|HTTPサーバ|Apache 2.4.63|
|ロードツール|JMeter 5.6.3|
|PHP|php-fpm 8.3.31|

## 4. 負荷試験方法

JMeterを用いて仮想サーバ（ホスト名：MonitorServer）に対し、事前に作成した負荷試験用PHPスクリプトへHTTPリクエストを送信し、負荷試験を実施しました。

各試験では JMeter ThreadGroupの設定を固定し、Thread数（仮想ユーザ数）のみを段階的に増加させることで、システム負荷の変化がスループットやOSリソースに与える影響を観察しました。

負荷試験は合計25回実施しています。

### 4.1. JMeter設定
- 各試験で使用したThreadGroupの設定は以下の通りです。
|項目|設定値|
|---|---|
|Ramp-up Period|10秒|
|Loop Count|Infinite|
|Duration|180秒|

- メトリクス収集で使用したListenerのオブジェクトは以下の通りです。
|項目|使用オブジェクト|
|---|---|
|Listener|Aggregate Report|

また、試験ごとにThread数のみを変更し、それ以外のパラメータはすべて同一条件としました。

### 4.2. データ収集方法

負荷試験中は、JMeterと自作のデータ収集スクリプトを使用し、スループットやCPU使用率などの各種メトリクスを収集しました。また、システムが定常状態に入った後のデータだけを評価対象とするので、各試験では以下のルールでデータを集計しています。

- 集計対象外：試験開始から30秒間（ウォームアップ期間）
- 集計対象　：残り150秒間（測定期間）

測定期間中に集計したデータは平均値を計算し、各試験の代表値として使用しました。

### 4.3. 負荷試験用PHPスクリプト

ApacheとPHP-FPMに対して軽量なCPUワークロードを与えるため、以下のPHPスクリプトを使用しました。
```php {filename="/var/www/html/cpu.php"}
##平方根計算と加算処理を繰り返し実行することで、CPU負荷を発生させています

<?php

$sum = 0;

##処理時間は約8msとなるようにループ回数を調整(2500回)
for($i=0;$i<2500;$i++){
    $sum += sqrt($i);
}

echo "Done : $sum";

?>
```

上記スクリプトで1リクエスト当たりの処理時間は、約8msであることが確認できています↓
``` {filename="MonitorServer"}
[root@MonitorServer ~]# time curl http://localhost/cpu.php
 Done : 83308.126280442   ←1リクエストの処理結果
 real 0m0.008s            ←1リクエスト当たり実請求時間に約0.008秒(8ミリ秒)
 user 0m0.003s
 sys 0m0.003s
```

### 4.4.データフロー
今回負荷試験のデータフローは以下のイメージです。
```mermaid
graph LR
　
    A[JMeter] -->|HTTPリクエスト| B[Apache]
    B -->|FastCGI| C[PHP-FPM]
    C --> D[cpu.php]
    D -->|CPUワークロード| E[CPUスケジューラ]

    C -->|HTTPレスポンス| B
    B -->|HTTPレスポンス| A
```

## 5. 観測指標
以下3観点から観測したい指標を選定しました。
|観点|指標|収集手段|
|---|---|---|
|HTTP性能|Throughput、Average、Median、90%、95%、99%、Max、Error%|Aggregate Report出力|
|CPUリソース|CPU Avg、Run Queue、Context Switch|vmstat、mpstatコマンド(自作スクリプト利用)|
|Apache状態|BusyWorkers、IdleWorkers、Processes|server-status?auto機能(自作スクリプト利用)|


各指標の収集手段、指標の意味は以下の通りです。



|指標|収集手段|説明|
|---|---|---|
|CPU Avg|mpstatコマンド(自作スクリプト)||
|Average|Aggregate Report出力|平均応答時間(ms)|
|Median|Aggregate Report出力|応答時間中央値(ms)|
|90% Line|Aggregate Report出力|
|95% Line|Aggregate Report出力|
|99% Line|Aggregate Report出力|
|Max|Aggregate Report出力|最大応答時間(ms)|
|Error %|Aggregate Report出力|リクエストの失敗率|
|Throughput|Aggregate Report出力|秒間リクエスト数|
|BusyWorkers Avg| |
|IdleWorkers Avg| |
|Processes Avg| |
|Context Switch| |
|Run Queue| |



## 6. 測定結果

|Test|Users|CPU Avg|Average|Median|90% Line|95% Line|99% Line|Max|Error%|Throughput|BusyWorkers Avg|IdleWorkers Avg|Processes Avg|Context Switch|Run Queue|
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
|#1|5|||||||||||||||||
|#2|10|||||||||||||||||
|#3|15|||||||||||||||||
|#4|20|||||||||||||||||
|#5|25|||||||||||||||||
|#6|30|||||||||||||||||
|：|：|||||||||||||||||


## 7. 考察

                        Apache Throughputのボトルネックを調査
                                   │
                 ┌─────────────────┴─────────────────┐
                 │                                   │
          仮説① CPU使用率が原因               仮説② Apache Worker数が原因
                 │                                   │
                 │                                   │
         CPU Utilizationを計測             BusyWorkers / IdleWorkersを計測
                 │                                   │
                 └─────────────────┬─────────────────┘
                                   │
                         十分な相関は確認できず
                                   │
                                   ▼
                   仮説③ CPU Resource Contentionが原因
                                   │
              ┌────────────────────┴────────────────────┐
              │                                         │
      Context Switchを計測                    Run Queueを計測
              │                                         │
              └────────────────────┬────────────────────┘
                                   │
                                   ▼
                  Throughputが頭打ちになる時点で
             Context Switch・Run Queueが急増することを確認
                                   │
                                   ▼
                    CPU SchedulerによるResource Contentionが
                  Throughput制限の主要因であることを検証


## 8. まとめ

今回の検証では、

①

CPU使用率だけでは性能限界を説明できなかった。

②

Apache Worker数も限界ではなかった。

③

Linux SchedulerによるCPU Resource Contentionが
Throughputを制限していたと考えられる。







