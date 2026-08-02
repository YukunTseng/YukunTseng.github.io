本プロジェクトの検証経過や分析内容などは個人ブログに記載しております。

[Project#01【性能調査】Apache HTTPサーバにおいて、Throughputを制限する要因は何か](https://yukuntseng.github.io/blog/sideprojects/apache-throughput-monitoring/ "Project#01【性能調査】Apache HTTPサーバにおいて、Throughputを制限する要因は何か")



## 概要

本リポジトリは、Apache HTTP Server に対する負荷試験を実施し、スループットを制限する要因を調査した検証プロジェクトです。
一般的にはCPU使用率やApache Worker数が性能指標として注目されますが、本検証では Linux カーネルのスケジューリング挙動にも着目し、

- Throughput
- CPU Utilization
- Apache Workers
- Context Switch
- Run Queue
- Response Time

を同時に観測しました。
その結果、CPU 使用率だけでは説明できない性能低下が確認され、LinuxスケジューラによるCPU Resource Contentionがスループットのボトルネックとなることを確認しました。

## 検証環境

|項目|製品|
|---|---|
|ハイパーバイザー|VMware(R) Workstation Pro 26H1|
|OS|Rocky Linux 10.1|
|HTTPサーバ|Apache 2.4.63|
|ロードツール|JMeter 5.6.3|
|PHP|php-fpm 8.3.31|

## システム構成

/images/構成図.jpgを参照してください。


## 負荷試験概要

JMeterのThread数を段階的に増加させ、合計25回の負荷試験を実施しました。

共通設定
Ramp-up：10 秒
Duration：180 秒
Warm-up：30 秒（除外）
Measurement：150 秒

Thread数
5⇒10⇒15⇒20⇒...1000

## 観測メトリクス

以下3観点から観測したい指標を選定しています。それぞれ指標の収集方法と観測目的は個人ブログを参照してください。

|観点|指標|収集手段|
|---|---|---|
|HTTP性能|Throughput、Average、Median、90%、95%、99%、Max、Error%|Aggregate Report出力|
|CPUリソース|CPU Avg、Run Queue、Context Switch|vmstat、mpstatコマンド(自作スクリプト利用)|
|Apache状態|BusyWorkers、IdleWorkers、Processes|server-status?auto機能(自作スクリプト利用)|

## 検証結果

本検証では以下の現象を確認しました。

- スループットは一定値以降ほぼ増加しなくなる
- CPU使用率は約75%付近で頭打ちとなる
- Apache Workerは枯渇していない
- Context Switchは増加する
- Run Queueも増加する
- Response Timeは急激に悪化する

これらの結果から、CPU使用率やApache Worker数ではなく、LinuxスケジューラによるCPU Resource Contentionがスループットの制限要因であることを確認しました。


## 本リポジトリに含まれるもの
- JMeter Test Plan
- PHP 負荷スクリプト
- データ収集スクリプト
- Excel 集計データ
- グラフ