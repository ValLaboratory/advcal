#!/usr/bin/env bash

# 
if [ $# -eq 0 ]; then
	echo 'Error: 引数に駅すぱあと路線図のアクセスキーを指定してください。'
	echo '  例） ./work_dir/hello_ews/setup_ews_gui.sh <アクセスキー>'
	exit 1
fi
ACCESS_KEY=$1

# 
if [ ! -d work_dir/ews_rosenz -o ! -d work_dir/ews_rosenz/public_html ]; then
	echo 'Error: docker_env ディレクトリでスクリプトを実行してください。'
	exit 1
fi

cd ./work_dir/ews_rosenz/public_html
sed -i "s/__ACCESS_KEY__/${ACCESS_KEY}/g" app.js

