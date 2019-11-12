#!/usr/bin/env bash

## 変数
add_pkg_aur=($@)
working_directory=/tmp/build_aur
number_of_pkg_aur=${#add_pkg_aur[*]}
export_directory=$(pwd)


## Rootチェック
if [[ $UID = 0 ]]; then
    echo "Rootで実行しないでください。"
    exit 1
fi


# 引数チェック
if [[ -z $@ ]]; then
    echo "何も指定されていません。"
    exit 1
fi


## Gitチェック
if [[ -z $( pacman -Q | awk '{print $1}' | grep -x "git" ) ]]; then
    sudo pacman -Syy
    sudo pacman -S git
fi


# 作業ディレクトリ作成
if [[ ! -d $working_directory ]]; then
    mkdir -p $working_directory
fi


## ビルド
for (( i=0; i<number_of_pkg_aur ; i++ )); do
    # Clone
    git clone https://aur.archlinux.org/${add_pkg_aur[$i]}.git $working_directory/${add_pkg_aur[$i]}
    # ビルド
    cd $working_directory/${add_pkg_aur[$i]}
    makepkg -s
    # 移動
    mv *.pkg.tar.xz $export_directory
    cd -
    # 削除
    rm -rf $working_directory/${add_pkg_aur[$i]}
done 

## 作業ディレクトリ削除
rm -r $working_directory