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
    # 必ずカスタムリポジトリのディレクトリを設定、作成してください。
    add_pkg_aur=()
}


## 関数定義
# 赤（エラー時）
function red_log () {
    echo -e "\033[0;31m$@\033[0;39m" >&2
    return 0
}

# 青（通常のログ）
function blue_log () {
    if [[ ! $log = 1 ]]; then
        echo -e "\033[0;34m$@\033[0;39m"
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

# エラーによる終了時の処理
function exit_error () {
    if [[ -d $working_directory ]]; then
        rm -rf $working_directory
    fi
    if [[ $msg_dl = 0 ]]; then
        rm $message_file_path
    fi
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
            echo -n  "一般ユーザー名を入力してください。 : "
            read aur_user
            if [[ -z $aur_user ]]; then
                ask_user
            fi
        }
        ask_user
        while [ $(user_check $aur_user) = 1 ]; do
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
build_aur_script_path=$working_directory/aur.bash


## ネット接続確認
blue_log "Checking network connection ..."
if [[ ! $(ping $check_url  -c 1 >> /dev/null ; echo $?) = 0 ]]; then
    red_log "There is no network connection."
    exit 1
else
    blue_log "The network connection was confirmed."
fi


## ベースメッセージ定義
en () {
    error_check_pkg="package_check : Please specify a package."
    error_root="You need root permission."
    error_archlinux="The script is able to run in ArchLinux only."
    error_pacman="Failed to execute because pacman was not found"
    error_working_dir_script="Do not specify the directory where the script exists in the working directory."
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
    debug_remote_archiso_ver="The remote archiso version is fixed at ${remote_archiso_version}."
    debug_local_archiso_ver="The local archiso version is fixed at ${local_archiso_version}."
    log_archiso_not_installed="ArchISO is not installed."
    log_install_archiso="Install ArchISO."
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
    red_log "作業ディレクトリとGitのCloneディレクトリを共通にすることはできません。"
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
case $make_arch in
    i686 ) : ;;
    x86_64 ) : ;;
    * ) red_log $error_architecture
        exit_error ;;
esac


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
        red_log $error_custom_archiso
        install_aur $archiso_package_name
        if [[ ! $? = 0 ]]; then
            red_log "AURから「$archiso_package_name」のインストールを試みましたが、何らかのエラーが原因で失敗しました。"
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
        * ) exit_error
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
    cp -r  $archiso_configs $working_directory
else
    red_log $error_confg_not_found
    if [[ $archiso_configs = "/usr/share/archiso/configs/releng/" ]]; then
        red_log $error_install_archiso
    else
        red_log $error_confg_not_found
    fi
    exit_error
fi


## カスタムパッケージの追記
blue_log $log_add_packages
for (( i=0; i<number_of_pkg ; i++ )); do
    echo ${add_pkg[$i]} >> $working_directory/packages.$make_arch
done 


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

    if [[ -n $add_pkg_aur ]]; then
        ## add_pkg_aur
        function add_aur_to_customrepo () {
            # aur.bashをダウンロード
            if [[ -f $build_aur_script_path ]]; then
                rm $build_aur_script_path
            fi
            wget -O $build_aur_script_path https://raw.githubusercontent.com/Hayao0819/archiso-helper/master/aur.bash
            # 一般ユーザーを設定
            if [[ -z $aur_user ]]; then
                ask_user () {
                    echo -n  "一般ユーザー名を入力してください。 : "
                    read aur_user
                    if [[ -z $aur_user ]]; then
                        ask_user
                    fi
                }
                ask_user
                while [ $(user_check $aur_user) = 1 ]; do
                    ask_user
                done
            fi
            # パッケージをaur.bashでビルド
            chmod 755 $build_aur_script_path
            #su $aur_user -c "$build_aur_script_path $1 $(dirname $build_aur_script_path)"
            su $aur_user -c "$build_aur_script_path $1"
            #パッケージを移動
            pkg_file=$(find $current_scriput_dir -name "$1*.pkg.tar.xz" )
            return 0
        }
        for (( i=0; i<number_add_pkg_aur ; i++ )); do
            add_aur_to_customrepo ${add_pkg_aur[$i]}
        done
    fi

    blue_log $log_generate_package_list
    if [[ -f $customrepo_directory/$make_arch/customrepo.db.tar.gz ]]; then
        rm customrepo.db
        rm customrepo.db.tar.gz
        rm customrepo.files
        rm customrepo.files.tar.gz
    fi
    repo-add customrepo.db.tar.gz *.pkg.tar.xz
    cd $current_scriput_dir
    blue_log $log_register_customrepo
    echo -e "[customrepo]\nSigLevel = Optional TrustAll\nServer = file://$customrepo_directory/$make_arch" >> $working_directory/pacman.conf

    ## customize_airootfs.shにて、カスタムリポジトリの設定を削除
    line_number=$(wc -l $working_directory/pacman.conf | awk '{print $1}')
    dqt='"'
    echo "sed -i $dqt$(( line_number - 2)),${line_number}d$dqt /etc/pacman.conf" >> $working_directory/airootfs/root/customize_airootfs.sh
    unset line_number
    unset dqt

fi


## ISO作成
blue_log $log_start_build
cd $working_directory
$working_directory/build.sh -v
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
if [[ -d $working_directory ]]; then
    blue_log $log_delete_working_dir
    rm -rf $working_directory
else
    red_log $error_working_dir_not_found
fi

if [[ -d $clone_temp && -z $archiso_configs_git ]]; then
    rm -r $clone_temp
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
