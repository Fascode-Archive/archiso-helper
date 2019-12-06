#!/usr/bin/env bash

if [[ -n $customize_airootfs_path ]]; then
    if [[ ! -f $customize_airootfs_path ]]; then
        red_log "customize_airootfs.shが存在しません。"
        exit_error
    fi
    cp -i $customize_airootfs_path $working_directory/airootfs/root/customize_airootfs.sh
fi