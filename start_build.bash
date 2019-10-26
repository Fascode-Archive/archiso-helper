#!/usr/bin/env bash

if [[ -f archlinux-builder.sh ]]; then
    rm archlinux-builder.sh
fi
wget -O archlinux-builder.sh https://0e0.pw/Kviw

if [[ -f settings.bash ]]; then
    rm settings.bash
fi
wget -O settings.bash https://0e0.pw/p-Ij

chmod 775 $(pwd)/archlinux-builder.sh
sudo $(pwd)/archlinux-builder.sh