#!/usr/bin/env bash

## 設定前変数
year=$(date "+%Y")
month=$(date "+%m")
day=$(date "+%d")
current_scriput_path=$(cd $(dirname $0) && pwd)/$(basename $0)
current_scriput_dir=$(pwd)
make_arch=$(uname -m)


## 設定読み込み

if [[ -n $1 ]]: then
    if [[ -f $1 ]]: then
        source $1
        if [[ $? = 0 ]]; then
            blue_log "外部設定ファイル$1が読み込まれました。"
        else
            red_log "外部設定ファイルの読み込みに失敗しました。"
            exit_error
        fi
    else
        red_log "外部設定ファイルが存在しません。"
        exit_error
    fi
else
    if [[ -f ./settings.conf ]]; then
        source ./settings.conf
        if [[ $? = 0 ]]; then
            blue_log "settings.confが読み込まれました。"
        else
            red_log "設定ファイルの読み込みに失敗しました。"
            exit_error
        fi
    else
        red_log "設定ファイルが見つかりませんでした。"
    fi
fi


## 設定後変数
number_of_pkg=${#add_pkg[*]}
number_add_pkg_aur=${#add_pkg_aur[*]}
build_aur_script_path=$working_directory/aur.bash
out_path=$out_dir/$out_name