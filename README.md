# webaccel-usage-slack
ウェブアクセラレータの転送量・課金額などをSlack通知するスクリプト

## 使い方

webaccel-usage-slack.sh に通知用情報を設定する。

```
webhookurl="https://hooks.slack.com/services/*************************"
channel_name="#*****"
username="webaccel-report"

sakura_cloud_api_secret="*****"
sakura_cloud_api_token="*****"
```

* Slack通知情報
  * webhookurl : 通知先Slackのwebhookurl
  * channel_name : 通知先Slackのchannel名
  * username : 通知時の名前

* さくらのクラウドのAPIキー（ウェブアクセラレータの情報取得用）
  *  sakura_cloud_api_secret : APIキーのアクセストークンシークレット
  *  sakura_cloud_api_token : APIキーのアクセストークン
