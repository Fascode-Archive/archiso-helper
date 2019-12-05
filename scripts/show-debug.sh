#!/usr/bin/env bash

if [[ ! $archiso_package_name = "archiso" ]]; then
    yellow_log $debug_archiso_package_name
fi
if [[ $bluelog = 1 ]]; then
    yellow_log $debug_log
fi
if [[ ! $archiso_configs = "/usr/share/archiso/configs/releng" ]]; then
    yellow_log $debug_archiso_conf
fi
if [[ -n $grub_background ]]; then
    yellow_log $debug_grub_background
fi
if [[ -n $overlay_directory ]]; then
    yellow_log $debug_overlay_dir
fi
if [[ -n $customrepo_directory ]]; then
    yellow_log   $debug_customrepo
fi
if [[ -n $customize_airootfs_path ]]; then
    yellow_log $debug_airootfs
fi
if [[ -n $add_pkg_aur ]]; then
    yellow_log $debug_aur
fi