#!/usr/bin/env bash

## 設定ファイルのURL
settings_url=https://raw.githubusercontent.com/Hayao0819/archlinux-latest-livecd-builder/master/settings.bash


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
wget -O /tmp/settings.bash $settings_url


## 権限付与と実行
chmod 775 /tmp/archlinux-builder.sh
sudo tmp//archlinux-builder.sh /tmp/settings.bash