#!/usr/bin/env bash

if [[ ! $UID = 0 ]]; then
    red_log "rootで実行してください。"
    if [[ $msg_dl = 0 ]]; then
        rm $message_file_path
    fi
    exit 1
fi