#!/usr/bin/env bash

if [[ -n $overlay_directory ]]; then
    if [[ ! -d $overlay_directory ]]; then
        red_log "オーバレイディレクトリが存在しません。"
        exit_error
    fi
    blue_log $log_copy_overlay_dir
    cp -ri $overlay_directory $working_directory/airootfs
fi