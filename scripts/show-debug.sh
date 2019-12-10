#!/usr/bin/env bash

if [[ ! $archiso_package_name = "archiso" ]]; then
    yellow_log "archisoのパッケージ名は$archiso_package_nameに変更されています。"
fi
if [[ ! $archiso_configs = "/usr/share/archiso/configs/releng" ]]; then
    yellow_log "archisoのプロファイルは$archiso_configsに変更されています。"
fi
if [[ -n $grub_background ]]; then
    yellow_log "Grubの背景は$grub_backgroundに変更されています。"
fi
if [[ -n $overlay_directory ]]; then
    yellow_log "オーバレイディレクトリは$overlay_directoryに変更されています。"
fi
if [[ -n $customrepo_directory ]]; then
    yellow_log  "カスタムリポジトリは$customrepo_directoryに設定されています。"
fi
if [[ -n $customize_airootfs_path ]]; then
    yellow_log "customize_airootfs.shは$customize_airootfs_pathに変更されています。"
fi
if [[ -n $add_pkg_aur ]]; then
    yellow_log "AURからadd_pkg_aurが追加されます。"
fi