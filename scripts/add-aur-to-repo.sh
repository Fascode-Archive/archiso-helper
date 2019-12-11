#!/usr/bin/env bash

if [[ -n $add_pkg_aur ]]; then
    # 一般ユーザーを設定
    if [[ -z $aur_user ]]; then
        ask_user () {
            echo -n $ask_general_user
            read aur_user
            if [[ -z $aur_user ]]; then
                red_log "ユーザー名を入力してください"
                ask_user
            fi
        }
        ask_user
        while [ $(user_check $aur_user) = 1 ]; do
            red_log "存在しているユーザを入力してください。"
            ask_user
        done
    fi
    # ディレクトリを作成
    if [[ -z $customrepo_directory ]]; then
        mkdir -p $current_scriput_dir/customrepo/$arch
        customrepo_directory=$current_scriput_dir/customrepo
        chown -R $aur_user $customrepo_directory
        # 自動でcustomrepoを生成した（0=yes 1=no）
        auto_make_customrepo=0
    elif [[ ! -d $customrepo_directory ]]; then
        mkdir -p $customrepo_directory/$arch
        chown -R $aur_user $customrepo_directory
        auto_make_customrepo=0
    else
        auto_make_customrepo=1
    fi
    cd $customrepo_directory/$arch
    function add_aur_to_customrepo () {
        # aur.bashをダウンロード
        if [[ -f $build_aur_script_path ]]; then
            rm $build_aur_script_path
        fi
        wget -O $build_aur_script_path https://raw.githubusercontent.com/Hayao0819/archiso-helper/master/aur.bash
        # パッケージをaur.bashでビルド
        chmod 755 $build_aur_script_path
        #su $aur_user -c "$build_aur_script_path $1 $(dirname $build_aur_script_path)"
        su $aur_user -c "$build_aur_script_path $1"
        #su $aur_user -c "$build_aur_script_path $1 $customrepo_directory/$arch"
        #パッケージを移動
        pkg_file=$(find $current_scriput_dir -name "$1*.pkg.tar.xz" )
        #blue_log "Generated $pkg_file"
        return 0
    }
    for (( i=0; i<number_add_pkg_aur ; i++ )); do
        add_aur_to_customrepo ${add_pkg_aur[$i]}
    done
    cd - > /dev/null
fi
