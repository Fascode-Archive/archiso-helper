#!/usr/bin/env bash


## 設定ファイルへのパス（引数で指定されていた場合は上書きされます。引数が間違っていた場合はこの設定が使用されます。）
settings_path=$(pwd)/settings.bash


## 変数定義（この設定は設定ファイルがない場合にのみ適用されます。）
#もし設定ファイルに変数が存在しない場合はこの設定が上書きされます。
function settings () {

    ###############################################
    # ディレクトリを指定する場合は最後に/を入れないでください。
    ###############################################


    ##言語
    #使用可能な言語はmessage.confで定義されている関数になります。
    msg_language="en"


    ## 作業ディレクトリ
    # このディレクトリ内に設定ファイル等を作成するため空のディレクトリを指定することをおすすめします。
    #~/などを指定するのはその中に大量のファイルを展開されてしまう恐れがあるためおすすめしません。
    working_directory="/tmp/archiso"


    ## 生成したいアーキテクチャ
    # i686 or x86_64）を入力してください（i686は非公式リポジトリを使用します。
    make_arch=x86_64


    ## 作成後のイメージファイルのパス
    # フルパスで表記してください。それぞれ${yaer}、${month}、${day}で年、月、日に置き換えることができます。
    # ${make_arch}で生成するアーキテクチャに置き換えることができます。
    # ここの値が不正な場合、失敗するか作業ディレクトリ/outに作成されます。
    image_file_path="/home/archlinux-${year}.${month}.${day}-${make_arch}.iso"


    ## 追加する公式リポジトリのパッケージ
    add_pkg=(linux networkmanager)


    ## 所有ユーザー名
    #作成後のISOイメージファイルの所有者
    user=root


    ## 所有グループ名（作成後のISOイメージファイルの所有グループ 空でwheelに設定）
    group=


    ## AURからのパッケージインストールに使う一般ユーザー
    # 設定されていない場合はAURインストール時に聞かれます。
    aur_user=


    ## 作成後のファイル権限
    perm=664


    ##対話時の自動返答（「yes」もしくは「no」空で自動返答を無効化）
    query=


    ##メッセージファイルへのパス
    message_file_path=$current_scriput_dir/message.conf


    ## MD5の作成（0=有効 1=無効 それ以外=無効）
    create_md5=0



    ###以下の設定は下手に変更すると重大な影響を及ぼします。必要な場合を除いて変更しないでください。



    ##ネットワークチェックのURL
    #ドメインもしくはIPのみを入力してください。
    check_url="google.com"


    ## archisoのパッケージ名です。
    # AURのパッケージ名にする場合は事前にインストールしておいてください。
    archiso_package_name="archiso"


    ## メッセージの出力
    # 0=有効 1=無効 それ以外=有効
    log=0 


    ## archisoのバージョンを固定
    # これらの値を変更するとArchISOのバージョン判定が正常に行えなくなります。（両方の値は必ず一致させてください。）
    local_archiso_version=
    remote_archiso_version=


    ##  i686用ビルドスクリプトへのパス
    i686_build_script=$current_scriput_dir/build_i686.sh


    ## archisoの設定プロファイルのGitのCloneのURL
    archiso_configs_git=""


    ## Gitの保存先
    clone_temp="$working_directory/git"


    ## archisoの設定プロファイルへのパス
    # Gitでクローンする場合は保存先以下のディレクトリを指定する必要があります。
    # クローン先ディレクトリとして${clone_temp}を指定できます
    archiso_configs="/usr/share/archiso/configs/releng"


    ## Grubの背景（フルパスで記述してください。デフォルトは空です。）
    grub_background=


    ## オーバーレイで追加するディレクトリ
    # ここで指定するディレクトリは/として認識されます。この値を設定する場合は非常に注意してください。デフォルトでは空です。
    # ArchISOのオーバーレイディレクトリを編集することをおすすめします。
    overlay_directory=


    ## customize_airootfs.shへのパス（パッケージのインストール後にrootとして実行されるスクリプトです。言語、タイムゾーン、ミラー等の設定を行います。）
    # /usr/share/archiso/configs/releng/airootfs/root/customize_airootfs.shを改造することをおすすめします。非常に重要なファイルであるため、値を変更する際は十分気をつけてください。デフォルトは空です。
    # customize_airootfs.shはovarlay_directoryを上書きします。ここで指定せず、overlay_directoryの/root/customized_airootfs.shを編集することでも変更できます。
    customize_airootfs_path=


    ## カスタムリポジトリのディレクトリ
    # このディレクトリ直下に必ずアーキテクチャ別のディレクトリを作成し、その中に*.pkg.tar.xzを配置してください。
    # 指定したパッケージをインストールする場合は必ずadd_pkgでパッケージ名を指定してください。
    customrepo_directory=


    ## カスタムリポジトリに追加するAURのパッケージ
    # 必ずカスタムリポジトリのディレクトリが設定されていない場合は作業ディレクトリ内に「customrepo」ディレクトリが作成されます。
    add_pkg_aur=()


    ## 追加する非公式リポジトリ
    # ディストリビューション作成等でインターネット上に公開されたリポジトリを追加する場合のみ設定してください。
    # ローカルリポジトリの設定は記述しないでください。
    # pacman.confに記述する変数の値をそれぞれ入力してください。
    # pacman.confの=のあとの値を記述してください。
    # 現在は「Server」と「SigLevel」のみ設定できます。
    # 非公式リポジトリを追加するかどうかはリポジトリ名が入力されているかどうかで判断されます。

    # [リポジトリ名] 
    add_repo_name=

    # Server
    add_repo_server=

    # SigLevel
    add_repo_siglevel=


    ## 作業ディレクトリを終了時に削除するかどうか
    # デバッグ用です。 0=削除する 1=削除しない それ以外=削除する
    delete_working_dir=
}


## 関数定義
# 赤（エラー時）
function red_log () {
    echo -e "\033[1;31m$@\033[0;39m" >&2
    return 0
}

# 青（通常のログ）
function blue_log () {
    if [[ ! $log = 1 ]]; then
        echo -e "\033[1;36m$@\033[0;39m"
    fi
    return 0
}

# 黄（注意、デバッグ）
function yellow_log () {
    if [[ ! $log = 1 ]]; then
        echo -e "\033[0;33m$@\033[0;39m" >&2
    fi
    return 0
}

# 白、タイトル等
function white_log () {
    if [[ ! $log = 1 ]]; then
        echo $@
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


## タイトル
white_log
white_log "==================================="
white_log "ArchISO Helper"
white_log "Mail: shun819.mail@gmail.com"
white_log "Twitter : @Hayao0819"
white_log "==================================="
white_log


## 設定前変数
year=$(date "+%Y")
month=$(date "+%m")
day=$(date "+%d")
current_scriput_path=$(cd $(dirname $0) && pwd)/$(basename $0)
current_scriput_dir=$(pwd)


## 設定読み込み
if [[ -n $1 && -f $1 ]]; then
    settings_path=$1
elif [[ -n $1 && ! -f $1 ]]; then
    red_log "The path to the configuration file is incorrect."
fi

settings

if [[ -z $settings_path ]]; then
    blue_log "Loaded settings $current_script_path"
else
    if [[ -f $settings_path ]]; then
        source $settings_path
        if [[ ! $? = 0 ]]; then
            blue_log "Loaded settings $current_script_path"
        else
            settings
            blue_log "Loaded settings $settings_path"
        fi
    else
        blue_log "Loaded settings $current_script_path"
    fi
fi


## 設定後変数
number_of_pkg=${#add_pkg[*]}
number_add_pkg_aur=${#add_pkg_aur[*]}
build_aur_script_path=$working_directory/aur.bash
make_arch=x86_64


## ネット接続確認
blue_log "Checking network connection ..."
if [[ ! $(ping $check_url  -c 1 >> /dev/null ; printf $?) = 0 ]]; then
    red_log "There is no network connection."
    exit 1
else
    blue_log "The network connection was confirmed."
fi


## ベースメッセージ定義
en () {
    error_check_pkg="package_check : Please specify a package."
    ask_general_user="Please enter a general user name. : "
    error_root="You need root permission."
    error_archlinux="The script is able to run in ArchLinux only."
    error_pacman="Failed to execute because pacman was not found"
    error_working_dir_script="Do not specify the directory where the script exists in the working directory."
    error_working_dir_git="The working directory and the Git Clone directory cannot be shared."
    error_filename="${image_file_path} already exists. Are you sure you want to overwrite it? (y/N) : "
    error_architecture="The architecture setting is incorrect."
    error_user="${user} is not exits."
    debug_archiso_package_name="The ArchISO package name is set to ${archiso_package_name}."
    debug_log="Log is disabled."
    debug_archiso_conf="The path to the configuration profile has been changed to ${archiso_configs}."
    debug_grub_background="Grub background is set to ${grub_background}."
    debug_overlay_dir="The G overlay directory is set to ${overlay_directory}."
    debug_customrepo="The custom repository is set to ${customrepo_directory}."
    debug_airootfs="The path of customize_airootfs.sh is set to ${customize_airootfs_path}."
    debug_aur="Automatically add ${add_pkg_aur[@]} from AUR."
    debug_remote_archiso_ver="The remote archiso version is fixed at ${remote_archiso_version}."
    debug_local_archiso_ver="The local archiso version is fixed at ${local_archiso_version}."
    log_archiso_not_installed="ArchISO is not installed."
    log_install_archiso="Install ArchISO."
    error_custom_archiso_install="An attempt to install ${archiso_package_name} from the AUR failed due to some error."
    error_custom_archiso="Install ${archiso_package_name} manually."
    log_archiso_iinstalled="ArchISO is installed."
    log_archiso_older="But ArchISO is not latest."
    log_archiso_upgrade="Update ArchISO."
    log_remote_archiso_ver="Installed  version: ${local_archiso_version}"
    log_local_archiso_ver="Repository version: ${remote_archiso_version}"
    log_archiso_newer="Installed ArchISO is newer than official repository."
    ask_delete_working_dir="Working directory already exists. Do you want to initialize it? (y/N) : "
    log_delete_working_dir="Deleting working directory."
    log_copy_config_dir="Copying settings to working directory."
    error_i686_not_found="i686's build.sh is not exist."
    error_git_not_installed="Git is not installed."
    log_config_clone="Clone the configuration file from Git."
    error_git_glone="Git Clone failed. The address may be wrong."
    error_confg_not_found="There is not ArchISO profiles."
    error_install_archiso="Please Install ArchISO manually."
    log_add_packages="Add custom packages to list."
    error_grub_background="The path to the Grub background is incorrect."
    error_overlay_dir="The overlay directory setting is invalid."
    log_copy_overlay_dir="Copying overlay directory ..."
    error_customize_airootfs="The path to customize_airootfs.sh is invalid."
    error_customrepo_dir="The custom repository directory does not exist."
    error_customrepo_architecture_dir="There are no custom repository directories by architecture."
    error_customrepo_setting_guide="Create a directory for each architecture directly under ${customrepo_directory} and put pkg.tar.xz in it."
    log_generate_package_list="generating custom repo list..."
    log_register_customrepo="adding custom packages..."
    log_start_build="Start building ArchLinux LiveCD."
    error_build="The build was interrupted due to some error."
    error_image_not_found="The image file that should have exist does not exist."
    error_run_again="Please run the script again."
    log_change_perm="CHanging permission of image file."
    error_pkg_md5='To generate MD5, you need to install "md5" package from AUR.'
    error_working_dir_not_found="${working_directory} is not found."
    log_image_builded="Created ArchLinux Live CD in ${image_file_path}."
    error_move_image="The image file could not be moved. The file may be in ${working_directory}/out/ ."
}


## メッセージ取得
if [[ ! $msg_language = "en" ]]; then
    if [[ ! -f $message_file_path ]]; then
        wget -O $message_file_path  https://raw.githubusercontent.com/Hayao0819/archlinux-latest-livecd-builder/master/message.conf
        msg_dl=0
    else
        msg_dl=1
    fi
    source $message_file_path
    if [[ -z $(type -t $msg_language) ]]; then
        red_log "The language is not currently available."
        exit_error
    elif [[ ! $(type -t $msg_language) = "function" ]]; then
        red_log "The language is not currently available."
        exit_error
    else
        blue_log "Loaded message $message_file_path"
    fi
    eval en
    eval $msg_language
else
    eval en
    blue_log "Loaded message $current_script_path"
fi


## Rootチェック
if [[ ! $UID = 0 ]]; then
    red_log $error_root
    if [[ $msg_dl = 0 ]]; then
        rm $message_file_path
    fi
    exit 1
fi


## ディストリビューションチェック
if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    if [[ ! $ID = "arch" ]]; then
        red_log $error_archlinux
        exit_error
    fi
else
    if [[ -n $(find /usr/bin/ -name "pacman" 2> /dev/null) ]]; then
        install_pacman lsb-release
        source  /etc/lsb-release
        if [[ ! $DISTRIB_ID = "Arch" ]]; then
            red_log $error_archlinux
            exit_error
        fi
    else
        red_log $error_pacman
        exit_error
    fi
fi


## 作業ディレクトリチェック
if [[ $current_scriput_dir = $working_directory ]]; then
    red_log $error_working_dir_script
    exit_error
fi


## Gitクローンディレクトリチェック
if [[ $clone_temp = $working_directory ]]; then
    red_log $error_working_dir_git
    exit_error
fi


## 出力先チェック
if [[ -f $image_file_path ]]; then
    if [[ -n $query ]];  then
        yn=$query
    else
        printf "$error_filename"
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


## アーキテクチャチェック
<< COMMENT
case $make_arch in
    i686 ) : ;;
    x86_64 ) : ;;
    * ) red_log $error_architecture
        exit_error ;;
esac
COMMENT


## ユーザーチェック
if [[ ! $(user_check $user ) = 0 ]]; then
    red_log $error_user
    exit_error
fi


## デバッグ変数の表示
if [[ ! $archiso_package_name = "archiso" ]]; then
    yellow_log $debug_archiso_package_name
fi
if [[ $bluelog = 1 ]]; then
    yellow_log $debug_log
fi
if [[ ! $archiso_configs = "/usr/share/archiso/configs/releng" ]]; then
    yellow_log $debug_archiso_conf
fi
if [[ -n $grub_background ]]; then
    yellow_log $debug_grub_background
fi
if [[ -n $overlay_directory ]]; then
    yellow_log $debug_overlay_dir
fi
if [[ -n $customrepo_directory ]]; then
    yellow_log   $debug_customrepo
fi
if [[ -n $customize_airootfs_path ]]; then
    yellow_log $debug_airootfs
fi
if [[ -n $add_pkg_aur ]]; then
    yellow_log $debug_aur
fi


## ArchISOインストール、アップグレード
if [[ -z $remote_archiso_version ]]; then
    remote_archiso_version=$(pacman -Ss  $archiso_package_name  | awk '{print $2}' | head -n 1)
else
    yellow_log $debug_remote_archiso_ver
fi

if [[ -z $local_archiso_version ]]; then
    local_archiso_version=$(pacman -Q "$archiso_package_name" | awk '{print $2}')
else
    yellow_log  $debug_local_archiso_ver
fi

if [[ $(package_check $archiso_package_name; printf $?) = 1 ]]; then
    yellow_log $log_archiso_not_installed
    yellow_log $log_install_archiso
    if [[ $archiso_package_name = "archiso" ]]; then
        install_pacman archiso
    else
        red_log $error_custom_archiso
        exit_error
    fi
elif [[ $local_archiso_version < $remote_archiso_version ]]; then
    yellow_log $log_archiso_iinstalled
    yellow_log $log_archiso_older
    yellow_log $log_archiso_upgrade
    yellow_log $log_remote_archiso_ver
    yellow_log $log_local_archiso_ver
    if [[ $archiso_package_name = "archiso" ]]; then
        install_pacman archiso
    else
        install_aur $archiso_package_name
        if [[ ! $? = 0 ]]; then
            red_log $error_custom_archiso_install
            red_log $error_custom_archiso
            exit_error
        fi
    fi
elif [[ $local_archiso_version > $remote_archiso_version ]]; then
    yellow_log $log_archiso_newer
    yellow_log $log_remote_archiso_ver
    yellow_log $log_local_archiso_ver
fi


## 作業ディレクトリ作成
if [[ ! -d $working_directory ]]; then
    mkdir -p $working_directory
    chmod 755 $working_directory
else
    if [[ -n $query ]];  then
        yn=$query
    else
        printf "$ask_delete_working_dir"
        read yn
    fi
    function del () {
        blue_log $log_delete_working_dir
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


## ArchISOプロファイルコピー
if [[ -d $archiso_configs ]]; then
    blue_log $log_copy_config_dir
    cp -r $archiso_configs/* $working_directory
    # i686追加処理
    if [[ $make_arch = "i686" ]]; then
        # i686用ビルドスクリプト
        if [[ ! -f $i686_build_script ]]; then
            red_log $error_i686_not_found
             wget https://raw.githubusercontent.com/Hayao0819/archlinux-latest-livecd-builder/master/build_i686.sh
        else
            # スクリプト移動
            rm $working_directory/build.sh
            cp $i686_build_script $working_directory/build.sh
        fi
    fi
# Git URL判定
elif [[  -n $(printf "$archiso_configs_git" | grep -Eo "http(s?)://(\w|:|%|#|\$|&|\?|\(|\)|~|\.|=|\+|\-|/)+")  ]]; then
    # Gitインストール
    if [[ $(package_check git; printf $?) = 1 ]]; then
        yellow_log  $error_git_not_installed
        install_pacman git
    fi
    blue_log $log_config_clone
    git clone $archiso_configs_git $clone_temp
    if [[ ! $? = 0 ]]; then
        red_log $error_git_clone
        exit_error
    fi
    cp -r  $archiso_configs/* $working_directory
else
    red_log $error_confg_not_found
    if [[ $archiso_configs = "/usr/share/archiso/configs/releng/" ]]; then
        red_log $error_install_archiso
    else
        red_log $error_confg_not_found
    fi
    exit_error
fi
if [[ ! -f $working_directory/build.sh ]]; then
    red_log "build.shがありません"
    exit_error
fi


## Grub背景の置き換え
if [[ -n $grub_background ]]; then
    if [[ ! -f $grub_background ]]; then
        red_log $error_grub_background
        exit_error
    fi
    cp $grub_background $working_directory/syslinux/splash.png
fi


## オーバーレイディレクトリのコピー
if [[ -n $overlay_directory ]]; then
    if [[ ! -d $overlay_directory ]]; then
        red_log $error_overlay_dir
        exit_error
    fi
    blue_log $log_copy_overlay_dir
    cp -ri $overlay_directory $working_directory/airootfs
fi


## customize_airootfs.shのコピー
if [[ -n $customize_airootfs_path ]]; then
    if [[ ! -f $customize_airootfs_path ]]; then
        red_log $error_customize_airootfs
        exit_error
    fi
    cp -i $customize_airootfs_path $working_directory/airootfs/root/customize_airootfs.sh
fi


## AURパッケージの追加
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
        mkdir -p $current_scriput_dir/customrepo/$make_arch
        customrepo_directory=$current_scriput_dir/customrepo
        chown -R $aur_user $customrepo_directory
        # 自動でcustomrepoを生成した（0=yes 1=no）
        auto_make_customrepo=0
    elif [[ ! -d $customrepo_directory ]]; then
        mkdir -p $customrepo_directory/$make_arch
        chown -R $aur_user $customrepo_directory
        auto_make_customrepo=0
    else
        auto_make_customrepo=1
    fi
    cd $customrepo_directory/$make_arch
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
        #su $aur_user -c "$build_aur_script_path $1 $customrepo_directory/$make_arch"
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


## カスタムリポジトリの追加
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


## 非公式リポジトリの追加
if [[ -n $add_repo_name ]]; then
    arch=$make_arch
    echo -e "[$add_repo_name]\nSigLevel = $add_repo_siglevel\nServer = $add_repo_server" >> $working_directory/pacman.conf
fi


## カスタムパッケージの追記
blue_log $log_add_packages
for (( i=0; i<number_of_pkg ; i++ )); do
    echo ${add_pkg[$i]} >> $working_directory/packages.$make_arch
done
for (( i=0; i<number_add_pkg_aur ; i++ )); do
    echo ${add_pkg_aur[$i]} >> $working_directory/packages.$make_arch
done


## ISO作成
blue_log $log_start_build
cd $working_directory
$working_directory/build.sh -v


#--------------------------------------------------------------#
# enable build
# verbose="-v"
# build.sh

<< COMMENT

set -e -u

iso_name=archlinux
iso_label="ARCH_$(date +%Y%m)"
iso_publisher="Arch Linux <http://www.archlinux.org>"
iso_application="Arch Linux Live/Rescue CD"
iso_version=$(date +%Y.%m.%d)
install_dir=arch
work_dir=work
out_dir=out
gpg_key=

verbose=""
script_path=$(readlink -f ${0%/*})

umask 0022

_usage ()
{
    echo "usage ${0} [options]"
    echo
    echo " General options:"
    echo "    -N <iso_name>      Set an iso filename (prefix)"
    echo "                        Default: ${iso_name}"
    echo "    -V <iso_version>   Set an iso version (in filename)"
    echo "                        Default: ${iso_version}"N
    echo "                        Default: '${iso_publisher}'"
    echo "    -A <application>   Set an application name for the disk"
    echo "                        Default: '${iso_application}'"
    echo "    -D <install_dir>   Set an install_dir (directory inside iso)"
    echo "                        Default: ${install_dir}"
    echo "    -w <work_dir>      Set the working directory"
    echo "                        Default: ${work_dir}"
    echo "    -o <out_dir>       Set the output directory"
    echo "                        Default: ${out_dir}"
    echo "    -v                 Enable verbose output"
    echo "    -h                 This help message"
    exit ${1}
}

# Helper function to run make_*() only one time per architecture.
run_once() {
    if [[ ! -e ${work_dir}/build.${1} ]]; then
        $1
        touch ${work_dir}/build.${1}
    fi
}

# Setup custom pacman.conf with current cache directories.
make_pacman_conf() {
    local _cache_dirs
    _cache_dirs=($(pacman -v 2>&1 | grep '^Cache Dirs:' | sed 's/Cache Dirs:\s*//g'))
    sed -r "s|^#?\\s*CacheDir.+|CacheDir = $(echo -n ${_cache_dirs[@]})|g" ${script_path}/pacman.conf > ${work_dir}/pacman.conf
}

# Base installation, plus needed packages (airootfs)
make_basefs() {
    mkarchiso ${verbose} -w "${work_dir}/x86_64" -C "${work_dir}/pacman.conf" -D "${install_dir}" init
    mkarchiso ${verbose} -w "${work_dir}/x86_64" -C "${work_dir}/pacman.conf" -D "${install_dir}" -p "haveged intel-ucode amd-ucode memtest86+ mkinitcpio-nfs-utils nbd zsh efitools" install
}

# Additional packages (airootfs)
make_packages() {
    mkarchiso ${verbose} -w "${work_dir}/x86_64" -C "${work_dir}/pacman.conf" -D "${install_dir}" -p "$(grep -h -v ^# ${script_path}/packages.x86_64)" install
}

# Copy mkinitcpio archiso hooks and build initramfs (airootfs)
make_setup_mkinitcpio() {
    local _hook
    mkdir -p ${work_dir}/x86_64/airootfs/etc/initcpio/hooks
    mkdir -p ${work_dir}/x86_64/airootfs/etc/initcpio/install
    for _hook in archiso archiso_shutdown archiso_pxe_common archiso_pxe_nbd archiso_pxe_http archiso_pxe_nfs archiso_loop_mnt; do
        cp /usr/lib/initcpio/hooks/${_hook} ${work_dir}/x86_64/airootfs/etc/initcpio/hooks
        cp /usr/lib/initcpio/install/${_hook} ${work_dir}/x86_64/airootfs/etc/initcpio/install
    done
    sed -i "s|/usr/lib/initcpio/|/etc/initcpio/|g" ${work_dir}/x86_64/airootfs/etc/initcpio/install/archiso_shutdown
    cp /usr/lib/initcpio/install/archiso_kms ${work_dir}/x86_64/airootfs/etc/initcpio/install
    cp /usr/lib/initcpio/archiso_shutdown ${work_dir}/x86_64/airootfs/etc/initcpio
    cp ${script_path}/mkinitcpio.conf ${work_dir}/x86_64/airootfs/etc/mkinitcpio-archiso.conf
    gnupg_fd=
    if [[ ${gpg_key} ]]; then
      gpg --export ${gpg_key} >${work_dir}/gpgkey
      exec 17<>${work_dir}/gpgkey
    fi
    ARCHISO_GNUPG_FD=${gpg_key:+17} mkarchiso ${verbose} -w "${work_dir}/x86_64" -C "${work_dir}/pacman.conf" -D "${install_dir}" -r 'mkinitcpio -c /etc/mkinitcpio-archiso.conf -k /boot/vmlinuz-linux -g /boot/archiso.img' run
    if [[ ${gpg_key} ]]; then
      exec 17<&-
    fi
}

# Customize installation (airootfs)
make_customize_airootfs() {
    cp -af ${script_path}/airootfs ${work_dir}/x86_64

    cp ${script_path}/pacman.conf ${work_dir}/x86_64/airootfs/etc

    curl -o ${work_dir}/x86_64/airootfs/etc/pacman.d/mirrorlist 'https://www.archlinux.org/mirrorlist/?country=all&protocol=http&use_mirror_status=on'

    lynx -dump -nolist 'https://wiki.archlinux.org/index.php/Installation_Guide?action=render' >> ${work_dir}/x86_64/airootfs/root/install.txt

    mkarchiso ${verbose} -w "${work_dir}/x86_64" -C "${work_dir}/pacman.conf" -D "${install_dir}" -r '/root/customize_airootfs.sh' run
    rm ${work_dir}/x86_64/airootfs/root/customize_airootfs.sh
}

# Prepare kernel/initramfs ${install_dir}/boot/
make_boot() {
    mkdir -p ${work_dir}/iso/${install_dir}/boot/x86_64
    cp ${work_dir}/x86_64/airootfs/boot/archiso.img ${work_dir}/iso/${install_dir}/boot/x86_64/archiso.img
    cp ${work_dir}/x86_64/airootfs/boot/vmlinuz-linux ${work_dir}/iso/${install_dir}/boot/x86_64/vmlinuz
}

# Add other aditional/extra files to ${install_dir}/boot/
make_boot_extra() {
    cp ${work_dir}/x86_64/airootfs/boot/memtest86+/memtest.bin ${work_dir}/iso/${install_dir}/boot/memtest
    cp ${work_dir}/x86_64/airootfs/usr/share/licenses/common/GPL2/license.txt ${work_dir}/iso/${install_dir}/boot/memtest.COPYING
    cp ${work_dir}/x86_64/airootfs/boot/intel-ucode.img ${work_dir}/iso/${install_dir}/boot/intel_ucode.img
    cp ${work_dir}/x86_64/airootfs/usr/share/licenses/intel-ucode/LICENSE ${work_dir}/iso/${install_dir}/boot/intel_ucode.LICENSE
    cp ${work_dir}/x86_64/airootfs/boot/amd-ucode.img ${work_dir}/iso/${install_dir}/boot/amd_ucode.img
    cp ${work_dir}/x86_64/airootfs/usr/share/licenses/amd-ucode/LICENSE ${work_dir}/iso/${install_dir}/boot/amd_ucode.LICENSE
}

# Prepare /${install_dir}/boot/syslinux
make_syslinux() {
    _uname_r=$(file -b ${work_dir}/x86_64/airootfs/boot/vmlinuz-linux| awk 'f{print;f=0} /version/{f=1}' RS=' ')
    mkdir -p ${work_dir}/iso/${install_dir}/boot/syslinux
    for _cfg in ${script_path}/syslinux/*.cfg; do
        sed "s|%ARCHISO_LABEL%|${iso_label}|g;
             s|%INSTALL_DIR%|${install_dir}|g" ${_cfg} > ${work_dir}/iso/${install_dir}/boot/syslinux/${_cfg##*/}
    done
    cp ${script_path}/syslinux/splash.png ${work_dir}/iso/${install_dir}/boot/syslinux
    cp ${work_dir}/x86_64/airootfs/usr/lib/syslinux/bios/*.c32 ${work_dir}/iso/${install_dir}/boot/syslinux
    cp ${work_dir}/x86_64/airootfs/usr/lib/syslinux/bios/lpxelinux.0 ${work_dir}/iso/${install_dir}/boot/syslinux
    cp ${work_dir}/x86_64/airootfs/usr/lib/syslinux/bios/memdisk ${work_dir}/iso/${install_dir}/boot/syslinux
    mkdir -p ${work_dir}/iso/${install_dir}/boot/syslinux/hdt
    gzip -c -9 ${work_dir}/x86_64/airootfs/usr/share/hwdata/pci.ids > ${work_dir}/iso/${install_dir}/boot/syslinux/hdt/pciids.gz
    gzip -c -9 ${work_dir}/x86_64/airootfs/usr/lib/modules/${_uname_r}/modules.alias > ${work_dir}/iso/${install_dir}/boot/syslinux/hdt/modalias.gz
}

# Prepare /isolinux
make_isolinux() {
    mkdir -p ${work_dir}/iso/isolinux
    sed "s|%INSTALL_DIR%|${install_dir}|g" ${script_path}/isolinux/isolinux.cfg > ${work_dir}/iso/isolinux/isolinux.cfg
    cp ${work_dir}/x86_64/airootfs/usr/lib/syslinux/bios/isolinux.bin ${work_dir}/iso/isolinux/
    cp ${work_dir}/x86_64/airootfs/usr/lib/syslinux/bios/isohdpfx.bin ${work_dir}/iso/isolinux/
    cp ${work_dir}/x86_64/airootfs/usr/lib/syslinux/bios/ldlinux.c32 ${work_dir}/iso/isolinux/
}

# Prepare /EFI
make_efi() {
    mkdir -p ${work_dir}/iso/EFI/boot
    cp ${work_dir}/x86_64/airootfs/usr/share/efitools/efi/PreLoader.efi ${work_dir}/iso/EFI/boot/bootx64.efi
    cp ${work_dir}/x86_64/airootfs/usr/share/efitools/efi/HashTool.efi ${work_dir}/iso/EFI/boot/

    cp ${work_dir}/x86_64/airootfs/usr/lib/systemd/boot/efi/systemd-bootx64.efi ${work_dir}/iso/EFI/boot/loader.efi

    mkdir -p ${work_dir}/iso/loader/entries
    cp ${script_path}/efiboot/loader/loader.conf ${work_dir}/iso/loader/
    cp ${script_path}/efiboot/loader/entries/uefi-shell-v2-x86_64.conf ${work_dir}/iso/loader/entries/
    cp ${script_path}/efiboot/loader/entries/uefi-shell-v1-x86_64.conf ${work_dir}/iso/loader/entries/

    sed "s|%ARCHISO_LABEL%|${iso_label}|g;
         s|%INSTALL_DIR%|${install_dir}|g" \
        ${script_path}/efiboot/loader/entries/archiso-x86_64-usb.conf > ${work_dir}/iso/loader/entries/archiso-x86_64.conf

    # EFI Shell 2.0 for UEFI 2.3+
    curl -o ${work_dir}/iso/EFI/shellx64_v2.efi https://raw.githubusercontent.com/tianocore/edk2/UDK2018/ShellBinPkg/UefiShell/X64/Shell.efi
    # EFI Shell 1.0 for non UEFI 2.3+
    curl -o ${work_dir}/iso/EFI/shellx64_v1.efi https://raw.githubusercontent.com/tianocore/edk2/UDK2018/EdkShellBinPkg/FullShell/X64/Shell_Full.efi
}

# Prepare efiboot.img::/EFI for "El Torito" EFI boot mode
make_efiboot() {
    mkdir -p ${work_dir}/iso/EFI/archiso
    truncate -s 64M ${work_dir}/iso/EFI/archiso/efiboot.img
    mkfs.fat -n ARCHISO_EFI ${work_dir}/iso/EFI/archiso/efiboot.img

    mkdir -p ${work_dir}/efiboot
    mount ${work_dir}/iso/EFI/archiso/efiboot.img ${work_dir}/efiboot

    mkdir -p ${work_dir}/efiboot/EFI/archiso
    cp ${work_dir}/iso/${install_dir}/boot/x86_64/vmlinuz ${work_dir}/efiboot/EFI/archiso/vmlinuz.efi
    cp ${work_dir}/iso/${install_dir}/boot/x86_64/archiso.img ${work_dir}/efiboot/EFI/archiso/archiso.img

    cp ${work_dir}/iso/${install_dir}/boot/intel_ucode.img ${work_dir}/efiboot/EFI/archiso/intel_ucode.img
    cp ${work_dir}/iso/${install_dir}/boot/amd_ucode.img ${work_dir}/efiboot/EFI/archiso/amd_ucode.img

    mkdir -p ${work_dir}/efiboot/EFI/boot
    cp ${work_dir}/x86_64/airootfs/usr/share/efitools/efi/PreLoader.efi ${work_dir}/efiboot/EFI/boot/bootx64.efi
    cp ${work_dir}/x86_64/airootfs/usr/share/efitools/efi/HashTool.efi ${work_dir}/efiboot/EFI/boot/

    cp ${work_dir}/x86_64/airootfs/usr/lib/systemd/boot/efi/systemd-bootx64.efi ${work_dir}/efiboot/EFI/boot/loader.efi

    mkdir -p ${work_dir}/efiboot/loader/entries
    cp ${script_path}/efiboot/loader/loader.conf ${work_dir}/efiboot/loader/
    cp ${script_path}/efiboot/loader/entries/uefi-shell-v2-x86_64.conf ${work_dir}/efiboot/loader/entries/
    cp ${script_path}/efiboot/loader/entries/uefi-shell-v1-x86_64.conf ${work_dir}/efiboot/loader/entries/

    sed "s|%ARCHISO_LABEL%|${iso_label}|g;
         s|%INSTALL_DIR%|${install_dir}|g" \
        ${script_path}/efiboot/loader/entries/archiso-x86_64-cd.conf > ${work_dir}/efiboot/loader/entries/archiso-x86_64.conf

    cp ${work_dir}/iso/EFI/shellx64_v2.efi ${work_dir}/efiboot/EFI/
    cp ${work_dir}/iso/EFI/shellx64_v1.efi ${work_dir}/efiboot/EFI/

    umount -d ${work_dir}/efiboot
}

# Build airootfs filesystem image
make_prepare() {
    cp -a -l -f ${work_dir}/x86_64/airootfs ${work_dir}
    mkarchiso ${verbose} -w "${work_dir}" -D "${install_dir}" pkglist
    mkarchiso ${verbose} -w "${work_dir}" -D "${install_dir}" ${gpg_key:+-g ${gpg_key}} prepare
    rm -rf ${work_dir}/airootfs
    # rm -rf ${work_dir}/x86_64/airootfs (if low space, this helps)
}

# Build ISO
make_iso() {
    mkarchiso ${verbose} -w "${work_dir}" -D "${install_dir}" -L "${iso_label}" -P "${iso_publisher}" -A "${iso_application}" -o "${out_dir}" iso "${iso_name}-${iso_version}-x86_64.iso"
}

if [[ ${EUID} -ne 0 ]]; then
    echo "This script must be run as root."
    _usage 1
fi

while getopts 'N:V:L:P:A:D:w:o:g:vh' arg; do
    case "${arg}" in
        N) iso_name="${OPTARG}" ;;
        V) iso_version="${OPTARG}" ;;
        L) iso_label="${OPTARG}" ;;
        P) iso_publisher="${OPTARG}" ;;
        A) iso_application="${OPTARG}" ;;
        D) install_dir="${OPTARG}" ;;
        w) work_dir="${OPTARG}" ;;
        o) out_dir="${OPTARG}" ;;
        g) gpg_key="${OPTARG}" ;;
        v) verbose="-v" ;;
        h) _usage 0 ;;
        *)
           echo "Invalid argument '${arg}'"
           _usage 1
           ;;
    esac
done

mkdir -p ${work_dir}

run_once make_pacman_conf
run_once make_basefs
run_once make_packages
run_once make_setup_mkinitcpio
run_once make_customize_airootfs
run_once make_boot
run_once make_boot_extra
run_once make_syslinux
run_once make_isolinux
run_once make_efi
run_once make_efiboot
run_once make_prepare
run_once make_iso

#--------------------------------------------------------------#
COMMENT

cd - > /dev/null
if [[ ! $? = 0 ]]; then
    red_log $error_build
    exit_error
fi


## イメージファイル移動
if [[ -z $( ls $working_directory/out ) ]]; then
    red_log $error_image_not_found
    red_log $error_run_again
    exit_error
fi
mv $working_directory/out/* $image_file_path


## MD5
if [[ $create_md5 = 0 ]]; then
    if [[ $(package_check md5; printf $?) = 1 ]]; then
        yellow_log $error_pkg_md5
        install_aur md5
    fi
    md5 $image_file_path  > $image_file_path.md5
fi


## 権限変更
blue_log $log_change_perm
if [[ -z $user ]]; then
    user=root
fi
if [[ -z $group ]]; then
    group=wheel
fi
chown $user:$group  $image_file_path
chmod $perm $image_file_path
chown $user:$group  $image_file_path.md5
chmod $perm $image_file_path.md5


## 作業ディレクトリ削除
if [[ -d $working_directory && ! $delete_working_dir = 1 ]]; then
    blue_log $log_delete_working_dir
    rm -rf $working_directory
else
    if [[ ! -d $working_directory ]]; then
        red_log $error_working_dir_not_found
    fi
fi


## Gitのcloneに使用したディレクトリを削除
if [[ -d $clone_temp && -z $archiso_configs_git ]]; then
    rm -r $clone_temp
fi


## 自動で作成したリポジトリを削除
if [[ $auto_make_customrepo = 0 ]]; then
    rm -r $customrepo_directory
fi


## ダウンロードしたメッセージファイルを削除
if [[ $msg_dl = 0 ]]; then
    rm $message_file_path
fi


## 作成後メッセージ
if [[ -f $image_file_path ]]; then
    blue_log $log_image_builded
else
    red_log $error_move_image
    exit_error
fi
