#!/usr/bin/env bash

if [[ -z $(cat ./lang-list | grep -w $lang ) ]]; then
    lang_bak=$lang
    lang=en
    red_log "$lang_bak is currently unavailable."
    exit_error
fi
