#!/usr/bin/env bash

if [[ -z $remote_archiso_version ]]; then
    remote_archiso_version=$(pacman -Ss  $archiso_package_name  | awk '{print $2}' | head -n 1)
else
    yellow_log $debug_remote_archiso_ver
fi

if [[ -z $local_archiso_version ]]; then
    local_archiso_version=$(pacman -Q "$archiso_package_name" | awk '{print $2}')
else
    yellow_log  $debug_local_archiso_ver
fi

if [[ $(package_check $archiso_package_name; printf $?) = 1 ]]; then
    yellow_log $log_archiso_not_installed
    yellow_log $log_install_archiso
    if [[ $archiso_package_name = "archiso" ]]; then
        install_pacman archiso
    else
        red_log $error_custom_archiso
        exit_error
    fi
elif [[ $local_archiso_version < $remote_archiso_version ]]; then
    yellow_log $log_archiso_iinstalled
    yellow_log $log_archiso_older
    yellow_log $log_archiso_upgrade
    yellow_log $log_remote_archiso_ver
    yellow_log $log_local_archiso_ver
    if [[ $archiso_package_name = "archiso" ]]; then
        install_pacman archiso
    else
        install_aur $archiso_package_name
        if [[ ! $? = 0 ]]; then
            red_log $error_custom_archiso_install
            red_log $error_custom_archiso
            exit_error
        fi
    fi
elif [[ $local_archiso_version > $remote_archiso_version ]]; then
    yellow_log $log_archiso_newer
    yellow_log $log_remote_archiso_ver
    yellow_log $log_local_archiso_ver
fi
