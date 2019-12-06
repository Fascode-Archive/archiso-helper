#!/usr/bin/env bash

if [[ -n $chroot_add_command ]]; then
    echo $chroot_add_command >> $working_directory/airootfs/root/customize_airootfs.sh
fi