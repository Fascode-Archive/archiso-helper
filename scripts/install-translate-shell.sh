#!/usrbin/env bash

if [[ $(package_check translate-shell ; printf $?) = 1 && ! $lang = "ja" ]]; then
    install_pacman translate-shell
fi
