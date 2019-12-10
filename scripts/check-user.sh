#!/usr/bin/env bash

if [[ ! $(user_check $user ) = 0 ]]; then
    red_log "ユーザーが存在しません。"
    exit_error
fi