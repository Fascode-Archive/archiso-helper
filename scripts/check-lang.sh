#!/usr/bin/env bash

if [[ -n $(cat ./lang-list | grep -w $msg_language ) ]]; then
    msg_language=en
    red_log "設定された言語は現在使用できません。"
    exit_error
fi
