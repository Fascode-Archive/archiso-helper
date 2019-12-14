#!/usr/bin/env bash

if [[ -d $archiso_configs ]]; then
    blue_log "プロファイルを作業ディレクトリにコピーしています。"
    cp -r $archiso_configs/* $working_directory
# Git URL判定
elif [[  -n $(printf "$archiso_configs_git" | grep -Eo "http(s?)://(\w|:|%|#|\$|&|\?|\(|\)|~|\.|=|\+|\-|/)+")  ]]; then
    # Gitインストール
    if [[ $(package_check git; printf $?) = 1 ]]; then
        yellow_log  "Gitをインストールします。"
        install_pacman git
    fi
    blue_log "Gitにあるプロファイルをダウンロードしています。"
    git clone $archiso_configs_git $clone_temp
    if [[ ! $? = 0 ]]; then
        red_log "Gitからのダウンロードに失敗しました。"
        exit_error
    fi
    cp -r  $archiso_configs/* $working_directory
else
    red_log "プロファイルが見つかりませんでした。"
    if [[ $archiso_configs = "/usr/share/archiso/configs/releng/" ]]; then
        red_log "archisoのインストールに失敗しました。"
    else
        red_log "プロファイルが存在していません。"
    fi
    exit_error
fi