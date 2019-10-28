#!/usr/bin/env bash

settings_url=https://raw.githubusercontent.com/Hayao0819/archlinux-latest-livecd-builder/master/settings.bash

if [[ -f /tmp/archlinux-builder.sh ]]; then
    rm /tmp/archlinux-builder.sh
fi
wget -O /tmp/archlinux-builder.sh https://0e0.pw/Kviw

if [[ -f /tmp/settings.bash ]]; then
    rm /tmp/settings.bash
fi
wget -O /tmp/settings.bash $settings_url

chmod 775 /tmp/archlinux-builder.sh
sudo tmp//archlinux-builder.sh