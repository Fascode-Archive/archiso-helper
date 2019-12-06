# 赤（エラー時）
function red_log () {
    if [[ -z $@ ]]; then
        echo
    else
        if [[ $msg_language = "ja" ]]; then
            echo -e "\033[1;31m$@\033[0;39m" >&2
        else
            echo -e "\033[1;31m$(trans -b -p ja:$msg_language $@)\033[0;39m" >&2
        fi
    fi
    return 0
}

# 青（通常のログ）
function blue_log () {
    if [[ -z $@ ]]; then
        echo
    else
        if [[ ! $log = 1 ]]; then
            if [[ $msg_language = "ja" ]]; then
                echo -e "\033[1;36m$@\033[0;39m"
            else
                echo -e "\033[1;36m$(trans -b -p ja:$msg_language $@)\033[0;39m"
            fi
        fi
    fi
    return 0
}

# 黄（注意、デバッグ）
function yellow_log () {
    if [[ -z $@ ]]; then
        echo
    else
        if [[ ! $log = 1 ]]; then
            if [[ $msg_language = "ja" ]]; then
                echo -e "\033[0;33m$@\033[0;39m" >&2
            else
                echo -e "\033[1;33m$(trans -b -p ja:$msg_language $@)\033[0;39m"
            fi
        fi
    fi
    return 0
}

# 白、タイトル等
function white_log () {
    if [[ -z $@ ]]; then
        echo
    else
        if [[ ! $log = 1 ]]; then
            if [[ $msg_language = "ja" ]]; then
                echo -e $@
            else
                echo -e "$(trans -b -p ja:$msg_language $@)"
            fi
        fi
    fi
    return 0
}

# パッケージがインストールされているか（終了コード0ならインストールされている、1ならされていない）
function package_check () {
    if [[ -z $1 ]]; then
        red_log $error_check_pkg
        exit 1
    fi
    if [[ -n $( pacman -Q $1 | awk '{print $1}' ) ]]; then
        return 0
    else
        return 1
    fi
}

# ユーザーが存在するか（oなら存在している、1ならしていない）
function user_check () {
    if [[ $(getent passwd $1 > /dev/null ; printf $?) = 0 ]]; then
        printf 0
        return 0
    else
        printf 1
        return 1
    fi
}

# パッケージのインストール
function install_pacman () {
    pacman -Syy --noconfirm
    pacman -S --noconfirm $@
}

# 余分なファイルを削除
cleanup () {
    if [[ -d $working_directory && ! $delete_working_dir = 1 ]]; then
        rm -rf $working_directory
    fi
    if [[ $msg_dl = 0 ]]; then
        rm $message_file_path
    fi
    if [[ $auto_make_customrepo = 0 && -d $customrepo_directory ]]; then
        rm -r $customrepo_directory
    fi
    if [[ -n $(printf "$archiso_configs_git" | grep -Eo "http(s?)://(\w|:|%|#|\$|&|\?|\(|\)|~|\.|=|\+|\-|/)+") && -d $clone_temp ]]; then
        rm -rf $clone_temp
    fi
}

# エラーによる終了時の処理
function exit_error () {
    cleanup
    exit 1
}

# 簡易AURヘルパー
# 現在複数パッケージの指定はできません
function install_aur () {
    aur=($@)
    # aur.bashをダウンロード
    if [[ -f $build_aur_script_path ]]; then
        rm $build_aur_script_path
    fi
    wget -O $build_aur_script_path https://raw.githubusercontent.com/Hayao0819/archiso-helper/master/aur.bash
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
    # パッケージをaur.bashでビルド
    chmod 755 $build_aur_script_path
    for (( i=0; i<$# ; i++ )); do
        #su $aur_user -c "$build_aur_script_path $1 $(dirname $build_aur_script_path)"
        su $aur_user -c "$build_aur_script_path ${aur[$i]}"
        #パッケージを移動
        pkg_file=$(find $current_scriput_dir -name "${aur[$i]}*.pkg.tar.xz" )
        mv $pkg_file $working_directory > /dev/null
        pkg_file=$(find $working_directory -name "${aur[$i]}*.pkg.tar.xz" )
        # 生成されたパッケージを検索してインストール
        pacman -Syy --noconfirm
        pacman -U --noconfirm $pkg_file
        rm $pkg_file
    done
    rm $build_aur_script_path
}
