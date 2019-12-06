#!/usr/bin/env bash

blue_log "Checking network connection ..."
if [[ ! $(ping $check_url  -c 1 >> /dev/null ; printf $?) = 0 ]]; then
    red_log "インターネットに接続されていません。"
    exit 1
else
    blue_log "インターネットに接続されています。"
fi