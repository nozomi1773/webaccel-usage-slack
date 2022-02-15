#!/bin/bash

webhookurl="https://hooks.slack.com/services/*************************"
channel_name="#*****"
username="webaccel-report"

sakura_cloud_api_secret="*****"
sakura_cloud_api_token="*****"

webaccel_api_baseurl="https://secure.sakura.ad.jp/cloud/zone/is1a/api/webaccel/1.0/"

target_month=$(date -d '1 days ago' '+%Y%m')
text_target_month=$(date -d '1 days ago' '+%Y年%m月')

which jq >/dev/null
rc=$?
if [ $rc -ne 0 ] ; then
	echo "jqをインストールしてください"
	exit
fi

jq_all=""
jq_all=$(curl -s --user "${sakura_cloud_api_token}":"${sakura_cloud_api_secret}" ${webaccel_api_baseurl}monthlyusage?target=${target_month} | jq '.MonthlyUsages[]')
rc=$?

if [ $rc -ne 0 ] ; then
	report="取得に失敗しました"
else
  report=$(echo "ドメイン"  "転送量"  "金額")"\n====================\n"
  for domain in $(echo $jq_all | jq '.Domain')
  do
    jq_domain=$(echo $jq_all | jq ". | select(.Domain == "$domain")")

    bytes_sent=$(echo $jq_domain | jq -c .BytesSent )
    bytes_sent=$(echo $bytes_sent | sed "s/\"//g" )
    gib_bytes_sent=$(bc <<< "scale=2; ${bytes_sent}/1024/1024/1024")

    price=$(echo $jq_domain | jq -c .Price )
    price=$(echo $price  | sed "s/\"//g" )

    domain=$(echo $domain | sed -e 's/"//g')
    report=${report}$(echo $domain :  $gib_bytes_sent GiB , $price "円" )"\n"
  done
fi

massage="ウェブアクセラレータ配信量レポート ${text_target_month}\n"
massage=$massage'```'$report'```'
curl -s -S -X POST --data-urlencode "payload={\"channel\": \"${channel_name}\", \"username\": \"${username}\", \"text\": \"${massage}\", \"icon_emoji\": \":ghost:\"}" $webhookurl  >/dev/null

exit

