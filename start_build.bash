#!/usr/bin/env bash

if [[ -z $@ ]]; then
    # 設定ファイルのパスを恒久的に変更する場合はこちらの値を使用してください。
    # URLかファイルパス、どちらでも問題ありません。
    settings_path=https://raw.githubusercontent.com/Hayao0819/archlinux-latest-livecd-builder/master/settings.bash
else
    case $@ in
        "lts" ) settings_path=https://raw.githubusercontent.com/Hayao0819/archlinux-lts-live/master/settings.bash;;
        "default" ) settings_path=https://raw.githubusercontent.com/Hayao0819/archlinux-latest-livecd-builder/master/settings.bash;;
        *) settings_path=$@;;
    esac
fi


## 古いファイルの削除
# archlinux-builder.sh
if [[ -f /tmp/archlinux-builder.sh ]]; then
    rm /tmp/archlinux-builder.sh
fi
# settings.bash
if [[ -f /tmp/settings.bash ]]; then
    rm /tmp/settings.bash
fi


## 新しいファイルのダウンロード
wget -O /tmp/archlinux-builder.sh https://0e0.pw/Kviw

if [[ -n $(printf "$settings_path" | grep -Eo "http(s?)://(\w|:|%|#|\$|&|\?|\(|\)|~|\.|=|\+|\-|/)+") ]]; then
    wget -O /tmp/settings.bash $settings_path
else
    if [[ -f $settings_path ]]; then
        cp $settings_path /tmp/settings.bash
    else
        echo "設定ファイルが存在しません" >&2
    fi
fi


## 権限付与と実行
chmod 775 /tmp/archlinux-builder.sh
sudo /tmp/archlinux-builder.sh /tmp/settings.bash