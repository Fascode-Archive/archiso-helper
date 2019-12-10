#!/usr/bin/env bash

if [[ ! -d $working_directory ]]; then
    mkdir -p $working_directory
    chmod 755 $working_directory
else
    if [[ -n $query ]];  then
        yn=$query
    else
        ask "既存の作業ディレクトリを削除してもよろしいですか？"
        read yn
    fi
    function del () {
        blue_log "既存の作業ディレクトリを削除しています。"
        rm -rf $working_directory
    }
    case $yn in
        y ) del ;;
        Y ) del ;;
        Yes ) del ;;
        yes ) del ;;
        * )   if [[ $msg_dl = 0 ]]; then
                  rm $message_file_path
              fi
              exit 1;;
    esac
    mkdir -p $working_directory
    chmod 755 $working_directory
    unset del
    unset yn
fi

if [[ ! -d $working_directory/out/ ]]; then
    mkdir -p $working_directory/out/
    chmod 755 $working_directory/out/
fi