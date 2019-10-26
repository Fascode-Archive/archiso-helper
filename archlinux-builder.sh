#!/usr/bin/env bash


## 設定ファイルへのパス（引数で指定されていた場合は上書きされます。引数が間違っていた場合はこの設定が使用されます。）
settings_path=$(pwd)/settings.bash


## 変数定義（この設定は設定ファイルがない場合にのみ適用されます。）
#もし設定ファイルに変数が存在しない場合はこの設定が上書きされます。
function settings () {

    ##言語
    #使用可能な言語はmessage.confで定義されている関数になります。
    msg_language="en"

    ## 作業ディレクトリ
    # このディレクトリ内に設定ファイル等を作成するため空のディレクトリを指定することをおすすめします。
    #~/などを指定するのはその中に大量のファイルを展開されてしまう恐れがあるためおすすめしません。
    working_directory="/home/archlinux-latest-livecd-builder"

    ## 生成したいアーキテクチャ
    # i686 or x86_64）を入力してください（i686は非公式リポジトリを使用します。
    make_arch=x86_64

    ## 作成後のイメージファイルのパス
    # フルパスで表記してください。それぞれ${yaer}、${month}、${day}で年、月、日に置き換えることができます。
    # ${make_arch}で生成するアーキテクチャに置き換えることができます。
    # ここの値が不正な場合、失敗するか作業ディレクトリ/outに作成されます。
    image_file_path="/home/archlinux-${year}.${month}.${day}-${make_arch}.iso"

    ## 追加するパッケージ
    add_pkg=(linux networkmanager)

    ## 所有ユーザー名
    #作成後のISOイメージファイルの所有者
    user=root

    ## 所有グループ名（作成後のISOイメージファイルの所有グループ 空でwheelに設定）
    group=

    ## 作成後のファイル権限
    perm=664

    ##対話時の自動返答（「yes」もしくは「no」空で自動返答を無効化）
    query=

    ##メッセージファイルへのパス
    message_file_path=$current_scriput_dir/message.conf


    ###以下の設定は下手に変更すると重大な影響を及ぼします。必要な場合を除いて変更しないでください。


    ##ネットワークチェックのURL
    check_url="https://google.com"

    ## archisoのパッケージ名です。
    # AURのパッケージ名にする場合は事前にインストールしておいてください。)
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
    clone_temp="/tmp"

    ## archisoの設定プロファイルへのパス
    #Gitでクローンする場合は保存先以下のディレクトリを指定する必要があります。
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
}


## 関数定義
function red_log () {
    echo -e "\033[0;31m$@\033[0;39m" >&2
    return 0
}

function blue_log () {
    if [[ ! $log = 1 ]]; then
        echo -e "\033[0;34m$@\033[0;39m"
    fi
    return 0
}

function yellow_log () {
    if [[ ! $log = 1 ]]; then
        echo -e "\033[0;33m$@\033[0;39m" >&2
    fi
    return 0
}

function white_log () {
    if [[ ! $log = 1 ]]; then
        echo $@
    fi
    return 0
}

function package_check () {
    if [[ -z $1 ]]; then
        red_log "Please specify a package."
        exit 1
    fi
    if [[ -n $( pacman -Q | awk '{print $1}' | grep -x "$1" ) ]]; then
        return 0
    else
        return 1
    fi
}

function user_check () {
    if [[ $(getent passwd $1 > /dev/null ; printf $?) = 0 ]]; then
        printf 0
        return 0
    else
        printf 1
        return 1
    fi
}

function install_pacman () {
    pacman -Syy --noconfirm
    pacman -S --noconfirm $@
}


## タイトル
white_log
white_log "==================================="
white_log "ArchLinux Latest LiveCD Builder"
white_log "==================================="
white_log


## 設定前変数
year=$(date "+%Y")
month=$(date "+%m")
day=$(date "+%d")
current_scriput_path=$(realpath "$0")
current_scriput_dir=$(pwd)


## 設定読み込み
if [[ -n $1 && -f $1 ]]; then
    settings_path=$1
elif [[ -n $1 && ! -f $1 ]]; then
    red_log "The path to the configuration file is incorrect."
fi

settings

if [[ -z $settings_path ]]; then
    blue_log "Loaded $current_script_path"
else
    if [[ -f $settings_path ]]; then
        source $settings_path
        check_import=$?
        if [[ ! $check_import = 0 ]]; then
            blue_log "Loaded $current_script_path"
        else
            blue_log "Loaded $settings_path"
        fi
    else
        blue_log "Loaded $current_script_path"
    fi
fi


## 設定後変数
number_of_pkg=${#add_pkg[*]}


## ネット接続確認
blue_log "Checking network connection ..."
if [[ ! $(ping $check_url  -c 1 >> /dev/null ; echo $?) = 0 ]]; then
    red_log "There is no network connection."
    exit 1
else
    blue_log "The network connection was confirmed."
fi


## メッセージ取得
if [[ ! -f $message_file_path ]]; then
    wget -O $message_file_path  https://raw.githubusercontent.com/Hayao0819/archlinux-latest-livecd-builder/master/message.conf
fi
source $message_file_path
if [[ -z $(type -t $msg_language) ]]; then
    red_log "The language is not currently available."
    exit 1
elif [[ ! $(type -t $msg_language) = "function" ]]; then
    red_log "The language is not currently available."
    exit 1
fi
$msg_language


## Rootチェック
if [[ ! $UID = 0 ]]; then
    red_log $error_root
    exit 1
fi


## ディストリビューションチェック
if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    if [[ ! $ID = "arch" ]]; then
        red_log $error_archlinux
        #exit 1
    fi
else
    if [[ -n $(find /usr/bin/ -name "pacman" 2> /dev/null) ]]; then
        install_pacman lsb-release
        source  /etc/lsb-release
        if [[ ! $DISTRIB_ID = "Arch" ]]; then
            red_log $error_archlinux
            #exit 1
        fi
    else
        red_log $error_pacman
        #exit 1
    fi
fi


## 作業ディレクトリチェック
if [[ $current_scriput_dir = $working_directory ]]; then
    red_log "作業ディレクトリにスクリプトが存在しているディレクトリを指定しないでください。"
    exit 1
fi


## 出力先チェック
if [[ -f $image_file_path ]]; then
    red_log $error_filename
    exit 1
fi


## アーキテクチャチェック
case $make_arch in
    i686 ) : ;;
    x86_64 ) : ;;
    * ) red_log $error_architecture
        exit 1 ;;
esac


## ユーザーチェック
if [[ ! $(user_check $user ) = 0 ]]; then
    red_log $error_user
    exit 1
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
    local_archiso_version=$(pacman -Q | grep "$archiso_package_name" | awk '{print $2}')
else
    yellow_log  $debug_local_archiso_ver
fi

if [[ $(package_check $archiso_package_name ; printf $?) = 1 ]]; then
    yellow_log $log_archiso_not_installed
    yellow_log $log_install_archiso
    if [[ $archiso_package_name = "archiso" ]]; then
        install_pacman archiso
    else
        red_log $error_custom_archiso
        exit 1
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
        exit 1
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
        * ) exit 1
    esac
    mkdir -p $working_directory
    chmod 755 $working_directory
fi

if [[ ! -d $working_directory/out/ ]]; then
    mkdir -p $working_directory/out/
    chmod 755 $working_directory/out/
fi


## ArchISOプロファイルコピー
if [[ -d $archiso_configs ]]; then
    blue_log $log_copy_config_dir
    cp -r $archiso_configs/* $working_directory
    if [[ $make_arch = "i686" ]]; then
        if [[ ! -f $i686_build_script ]]; then
            red_log $error_i686_not_found
             wget https://raw.githubusercontent.com/Hayao0819/archlinux-latest-livecd-builder/master/build_i686.sh
        else
            rm $working_directory/build.sh
            cp $i686_build_script $working_directory/build.sh
        fi
    fi
elif [[  -n $(printf "$archiso_configs_git" | grep -Eo "http(s?)://(\w|:|%|#|\$|&|\?|\(|\)|~|\.|=|\+|\-|/)+")  ]]; then
    if [[ $(package_check git ; printf $?) = 1 ]];
        #Gitパッケージの判定 いつか自動インストールにしたい
        red_log $error_git_not_installed
        exit 1
    fi
    blue_log $log_config_clone
    git clone $archiso_configs_git $clone_temp
    if [[ ! $? = 0 ]]; then
        red_log $error_git_clone
        exit 1
    fi
    cp -r  $archiso_configs $working_directory
else
    red_log $error_confg_not_found
    if [[ $archiso_configs = "/usr/share/archiso/configs/releng/" ]]; then
        red_log $error_install_archiso
    else
        red_log $error_confg_not_found
    fi
    exit 1
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
        exit 1
    fi
    cp $grub_background $working_directory/syslinux/splash.png
fi


## オーバーレイディレクトリのコピー
if [[ -n $overlay_directory ]]; then
    if [[ ! -d $overlay_directory ]]; then
        red_log $error_overlay_dir
        exit 0
    fi
    blue_log $log_copy_overlay_dir
    cp -ri $overlay_directory $working_directory/airootfs
fi


## customize_airootfs.shのコピー
if [[ -n $customize_airootfs_path ]]; then
    if [[ ! -f $customize_airootfs_path ]]; then
        red_log $error_customize_airootfs
        exit 1
    fi
    cp -i $customize_airootfs_path $working_directory/airootfs/root/customize_airootfs.sh
fi


## カスタムリポジトリの追加
if [[ -n $customrepo_directory  ]]; then
    if [[ ! -d $customrepo_directory ]]; then
        red_log $error_customrepo_dir
        exit 1
    fi
    if [[ ! -d $customrepo_directory/$make_arch ]]; then
        red_log $error_customrepo_architecture_dir
        red_log $error_customrepo_setting_guide
        exit 1
    fi
    cd $customrepo_directory/$make_arch
    blue_log $log_generate_package_list
    repo-add customrepo.db.tar.gz *.pkg.tar.xz
    cd $current_scriput_dir
    blue_log $log_register_customrepo
    echo -e "
    [customrepo]\n
    SigLevel = Optional TrustAll\n
    Server = file://$working_directory/$make_arch\n
    " >> $working_directory/pacman.conf
fi


## ISO作成
blue_log "Start building ArchLinux LiveCD."
cd $working_directory
./build.sh -v


## イメージファイル移動
if [[ -z $( ls $working_directory/out ) ]]; then
    red_log $error_image_not_found
    red_log $error_run_again
    exit 1
fi
mv $working_directory/out/* $image_file_path


## 権限変更
blue_log $log_change_perm
if [[ -z $group ]]; then
    group=wheel
fi
chown $user:$group  $image_file_path
chmod $perm $image_file_path


## 作業ディレクトリ削除
if [[ -d $working_directory ]]; then
    blue_log $log_delete_working_dir
    rm -rf $working_directory
else
    red_log $error_working_dir_not_found
fi

if [[ -d $clone_temp ]]; then
    rm -r $clone_temp
fi


## 作成後メッセージ
if [[ -f $image_file_path ]]; then
    blue_log $log_image_builded
else
    red_log $error_move_image
    exit 1
fi
