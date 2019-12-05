#!/usr/bin/env bash


script_dir=./scripts


# 初期値読み込み
source ./initial.sh


# スクリプトを実行
run () {
    source $@
}


## タイトル
run $script_dir/start.sh


## 設定
run $script_dir/load-settings.sh

