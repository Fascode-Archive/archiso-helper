#!/usr/bin/env bash

if [[ -f $out_path ]]; then
    if [[ -n $query ]];  then
        yn=$query
    else
        ask "既に$out_pathは存在しています。上書きしてもよろしいですか？"
        read yn
    fi
    function del () {
        rm $out_path
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