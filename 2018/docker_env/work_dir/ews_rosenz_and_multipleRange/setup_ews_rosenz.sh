#!/usr/bin/env bash

# 
if [ -z "$1" ]; then
	echo 'Error: 引数に駅すぱあと路線図のアクセスキーを指定してください。'
	echo '  例） ./work_dir/hello_ews/setup_ews_gui.sh <駅すぱあと路線図のアクセスキー> <駅すぱあとWebサービスのアクセスキー>'
	exit 1
fi
if [ -z "$2" ]; then
	echo 'Error: 引数に駅すぱあとWebサービスのアクセスキーを指定してください。'
	echo '  例） ./work_dir/hello_ews/setup_ews_gui.sh <駅すぱあと路線図のアクセスキー> <駅すぱあとWebサービスのアクセスキー>'
	exit 1
fi
ROSENZ_ACCESS_KEY=$1
EWS_ACCESS_KEY=$2

# 
if [ ! -d work_dir/ews_rosenz -o ! -d work_dir/ews_rosenz/public_html ]; then
	echo 'Error: docker_env ディレクトリでスクリプトを実行してください。'
	exit 1
fi

cd ./work_dir/ews_rosenz_and_multipleRange/public_html
sed -i "s/__ROSENZ_ACCESS_KEY__/${ROSENZ_ACCESS_KEY}/g" app.js
sed -i "s/__EWS_ACCESS_KEY__/${EWS_ACCESS_KEY}/g" app.js

