#!/usrbin/env bash

if [[ $(package_check translate-shell ; printf $?) = 1 && ! $msg_language = "ja" ]]; then
    install_pacman translate-shell
fi
