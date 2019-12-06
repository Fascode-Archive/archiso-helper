#!/usr/bin/env bash

if [[ -f $image_file_path ]]; then
    if [[ -n $query ]];  then
        yn=$query
    else
        ask "$image_file_pathは既に存在しています。上書きしてもよろしいですか？"
        read yn
    fi
    function del () {
        rm $image_file_path
    }
    case $yn in
        y ) del ;;
        Y ) del ;;
        Yes ) del ;;
        yes ) del ;;
        * ) exit_error
    esac
    unset yn
    unset del
fi