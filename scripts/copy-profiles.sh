#!/usr/bin/env bash

if [[ -d $archiso_configs ]]; then
    blue_log $log_copy_config_dir
    cp -r $archiso_configs/* $working_directory
# Git URL判定
elif [[  -n $(printf "$archiso_configs_git" | grep -Eo "http(s?)://(\w|:|%|#|\$|&|\?|\(|\)|~|\.|=|\+|\-|/)+")  ]]; then
    # Gitインストール
    if [[ $(package_check git; printf $?) = 1 ]]; then
        yellow_log  $error_git_not_installed
        install_pacman git
    fi
    blue_log $log_config_clone
    git clone $archiso_configs_git $clone_temp
    if [[ ! $? = 0 ]]; then
        red_log $error_git_clone
        exit_error
    fi
    cp -r  $archiso_configs/* $working_directory
else
    red_log $error_confg_not_found
    if [[ $archiso_configs = "/usr/share/archiso/configs/releng/" ]]; then
        red_log $error_install_archiso
    else
        red_log $error_confg_not_found
    fi
    exit_error
fi
if [[ ! -f $working_directory/build.sh ]]; then
    red_log "build.shがありません"
    exit_error
fi
