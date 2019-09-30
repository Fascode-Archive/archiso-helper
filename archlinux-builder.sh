#!/usr/bin/env bash

## 変数定義
year=`date "+%Y"`
month=`date "+%m"`
day=`date "+%d"`

## 設定
working_directory="/home/arch-build" # このディレクトリ内に設定ファイル等を作成するため空のディレクトリを指定することをおすすめします。
image_file_name="archlinux-${year}.${month}.${day}-x86_64.iso" # それぞれ${yaer}、${month}、${day}で年、月、日に置き換えることができます。

## Rootチェック
if [[ ! $UID = 0 ]]; then
    echo "You need root permission." >&2
    exit 1
fi

## ディストリビューションチェック
if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    if [[ ! $ID = "arch" ]]; then
        echo "The script is able to run in ArchLinux only." >&2
        exit 1
    fi
else
    echo "There is not /etc/os-release."
    exit 1
fi

## 関数定義
package_check () {
    if [[ -n $( pacman -Q | awk '{print $1}' | grep -x "$1" ) ]]; then
        return 0
    else
        return 1
    fi
}

## ArchISOインストール
if [[ $(package_check archiso) = 1 ]]; then
    pacman -Syy
    pacman -S archiso
fi