#!/usr/bin/env bash

if [[ $clone_temp = $working_directory ]]; then
    red_log "作業ディレクトリとGitディレクトリを共通にすることはできません。"
    exit_error
fi