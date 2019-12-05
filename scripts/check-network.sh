#!/usr/bin/env bash

blue_log "Checking network connection ..."
if [[ ! $(ping $check_url  -c 1 >> /dev/null ; printf $?) = 0 ]]; then
    red_log "There is no network connection."
    exit 1
else
    blue_log "The network connection was confirmed."
fi