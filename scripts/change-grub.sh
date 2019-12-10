#!/usr/bin/env bash

if [[ -n $grub_background ]]; then
    if [[ ! -f $grub_background ]]; then
        red_log "Grub背景用の画像が存在しません。"
        exit_error
    fi
    image_size_w=$(identify -format '%w' $grub_background)
    image_size_h=$(identify -format '%h' $grub_background)
    if [[ $image_size_w = "640" && $image_size_h = "480" ]]; then
        cp $grub_background $working_directory/syslinux/splash.png
    else
        red_log "画像サイズは640x480のみ有効です。"
        exit_error
    fi
fi
