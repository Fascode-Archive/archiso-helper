#!/usr/bin/env bash

if [[ $current_scriput_dir = $working_directory ]]; then
    red_log "スクリプトがあるディレクトリを作業ディレクトリにすることはできません。"
    exit_error
fi