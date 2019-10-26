#!/usr/bin/env bash

settings_url=https://raw.githubusercontent.com/Hayao0819/archlinux-latest-livecd-builder/master/settings.bash


if [[ -f archlinux-builder.sh ]]; then
    rm archlinux-builder.sh
fi
wget -O archlinux-builder.sh https://0e0.pw/Kviw

if [[ -f settings.bash ]]; then
    rm settings.bash
fi
wget -O settings.bash $settings_url

chmod 775 $(pwd)/archlinux-builder.sh
sudo $(pwd)/archlinux-builder.sh