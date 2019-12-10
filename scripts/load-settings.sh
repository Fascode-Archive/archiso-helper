#!/usr/bin/env bash

## 設定前変数
year=$(date "+%Y")
month=$(date "+%m")
day=$(date "+%d")
current_scriput_path=$(cd $(dirname $0) && pwd)/$(basename $0)
current_scriput_dir=$(pwd)
make_arch=$(uname -m)


## 設定読み込み

if [[ -f ./settings.conf ]]; then
    source ./settings.conf
    if [[ $? = 0 ]]; then
        blue_log "settings.confが読み込まれました。"
    fi
else
    red_log "設定ファイルが見つかりませんでした。"
fi



## 設定後変数
number_of_pkg=${#add_pkg[*]}
number_add_pkg_aur=${#add_pkg_aur[*]}
build_aur_script_path=$working_directory/aur.bash
make_arch=$(uname -m)
image_file_path=$image_file_dir/$image_file_name