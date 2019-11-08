#!/usr/bin/env bash

add_pkg_aur=()
number_of_pkg_aur=${#add_pkg_aur[*]}
current_dir=$(pwd)
if [[ $UID = 0 ]]; then
    echo "Rootで実行しないでください。"
    exit 1
fi
if [[ -z $( pacman -Q | awk '{print $1}' | grep -x "git" ) ]]; then
    sudo pacman -Syy
    sudo pacman -S git
fi
if [[ ! -d /tmp/build_aur ]]; then
    mkdir -p /tmp/build_aur
fi
for (( i=0; i<number_of_pkg_aur ; i++ )); do
    git clone httos://aur.archlinux.org/${add_pkg_aur[$i]}.git /tmp/build_aur/${add_pkg_aur[$i]}
    cd /tmp/build_aur/${add_pkg_aur[$i]}
    makepkg -s
    mv *.pkg.tar.xz $current_dir
    cd -
done 