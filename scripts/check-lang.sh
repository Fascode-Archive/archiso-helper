#!/usr/bin/env bash

if [[ -z $(cat ./lang-list | grep -w $msg_language ) ]]; then
    msg_language_bak=$msg_language
    msg_language=en
    red_log "$msg_language_bak is currently unavailable."
    exit_error
fi
