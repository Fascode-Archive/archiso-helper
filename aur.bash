#!/usr/bin/env bash

add_pkg_aur=($@)
working_directory=/tmp/build_aur
number_of_pkg_aur=${#add_pkg_aur[*]}
current_dir=$(pwd)
if [[ $UID = 0 ]]; then
    echo "Rootで実行しないでください。"
    exit 1
fi
if [[ -n $@ ]]; then
    echo "何も指定されていません。"
    exit 1
fi
if [[ -z $( pacman -Q | awk '{print $1}' | grep -x "git" ) ]]; then
    sudo pacman -Syy
    sudo pacman -S git
fi
if [[ ! -d $working_directory ]]; then
    mkdir -p $working_directory
fi
for (( i=0; i<number_of_pkg_aur ; i++ )); do
    git clone https://aur.archlinux.org/${add_pkg_aur[$i]}.git $working_directory/${add_pkg_aur[$i]}
    cd $working_directory/${add_pkg_aur[$i]}
    makepkg -s
    mv *.pkg.tar.xz $current_dir
    cd -
    rm -rf $working_directory/${add_pkg_aur[$i]}
done 
rm -r $w