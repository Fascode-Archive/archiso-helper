#!/usr/bin/env bash

if [[ -n $customrepo_directory  ]]; then
    # ディレクトリ作成、チェック
    if [[ ! -d $customrepo_directory ]]; then
        red_log $error_customrepo_dir
        exit_error
    fi
    if [[ ! -d $customrepo_directory/$make_arch ]]; then
        red_log $error_customrepo_architecture_dir
        red_log $error_customrepo_setting_guide
        exit_error
    fi
    cd $customrepo_directory/$make_arch
    blue_log $log_generate_package_list
    if [[ -f $customrepo_directory/$make_arch/customrepo.db.tar.gz ]]; then
        rm customrepo.db
        rm customrepo.db.tar.gz
        rm customrepo.files
        rm customrepo.files.tar.gz
    fi
    repo-add customrepo.db.tar.gz *.pkg.tar.xz
    cd - > /dev/null
    blue_log $log_register_customrepo

    # 注意：パッケージの認証を行う場合は上のコメントを外し、下をコメントアウトしてください。
    # デフォルトではカスタムリポジトリのパッケージ認証は行いません。
    #echo -e "[customrepo]\nSigLevel = Optional TrustAll\nServer = file://$customrepo_directory/$make_arch" >> $working_directory/pacman.conf
    echo -e "[customrepo]\nSigLevel = Never TrustAll\nServer = file://$customrepo_directory/$make_arch" >> $working_directory/pacman.conf

    ## customize_airootfs.shにて、カスタムリポジトリの設定を削除
    line_number=$(wc -l $working_directory/pacman.conf | awk '{print $1}')
    dqt='"'
    echo "sed -i $dqt$(( line_number - 2)),${line_number}d$dqt /etc/pacman.conf" >> $working_directory/airootfs/root/customize_airootfs.sh
    unset line_number
    unset dqt

fi