#!/usr/bin/env bash

if [[ $no_build = 0 ]]; then
    ## ダウンロードしたメッセージファイルを削除
    if [[ $msg_dl = 0 ]]; then
        rm $message_file_path
    fi
    mv $working_directory $(dirname $out_path)
    exit 0
fi
blue_log "ビルドを開始します。"
cd $working_directory

if [[ $build_script = "include" ]]; then
    build
else
    chmod +x $build_script
    bash $build_script -v
fi

cd - > /dev/null
if [[ ! $? = 0 ]]; then
    red_log $error_build
    exit_error
fi