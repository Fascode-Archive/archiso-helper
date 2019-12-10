#!/usr/bin/env bash

if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    if [[ ! $ID = "arch" && ! $ID = "arch32" ]]; then
        red_log "このスクリプトはArchLinuxでのみ実行できます。"
        exit_error
    fi
else
    if [[ -n $(find /usr/bin/ -name "pacman" 2> /dev/null) ]]; then
        install_pacman lsb-release
        source  /etc/lsb-release
        if [[ ! $DISTRIB_ID = "Arch" ]]; then
            red_log "このスクリプトはArchLinuxでのみ実行できます。"
            exit_error
        fi
    else
        red_log "pacmanと/etc/os-releaseが無いためディストリビューションのチェックに失敗しました。"
        exit_error
    fi
fi