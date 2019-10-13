#!/usr/bin/env bash


## 設定ファイルへのパス
settings_path=$(pwd)/settings.bash


## 変数定義（この設定は設定ファイルがない場合にのみ適用されます。）
function settings () {
    # このディレクトリ内に設定ファイル等を作成するため空のディレクトリを指定することをおすすめします。
    working_directory="/home/archlinux-latest-livecd-builder"
    # フルパスで表記してください。それぞれ${yaer}、${month}、${day}で年、月、日に置き換えることができます。
    image_file_path="/home/archlinux-${year}.${month}.${day}-x86_64.iso"
    # 生成したいアーキテクチャ（i686 or x86_64）を入力してください（i686は非公式リポジトリを使用します）
    make_arch=x86_64
    # 追加するパッケージ
    add_pkg=(linux networkmanager)
    # 所有ユーザー名（作成後のISOイメージファイルの所有者）
    user=root
    # 所有グループ名（作成後のISOイメージファイルの所有グループ 空でwheelに設定）
    group=
    # 作成後のファイル権限
    perm=664
    #対話時の自動返答（「yes」もしくは「no」空で自動返答を無効化）
    query=

    # archisoのパッケージ名です。(AURのパッケージ名にする場合は事前にインストールしておいてください。)
    archiso_package_name="archiso"
    # メッセージの出力（0=有効 1=無効 それ以外=有効）
    bluelog=0 
    # これらの値を変更するとArchISOのバージョン判定が正常に行えなくなります。ArchISOのバージョンを固定する場合にのみ、両方の値を変更してください。（両方の値は必ず一致させてください。）
    local_archiso_version=
    remote_archiso_version= 
    # i686用ビルドスクリプトへのパス
    i686_build_script=$current_scriput_dir/build_i686.sh
    # archisoの設定プロファイルへのパス
    archiso_configs="/usr/share/archiso/configs/releng"
    # Grubの背景（フルパスで記述してください。デフォルトは空です。）
    grub_background=
    # オーバーレイで追加するディレクトリ（ここで指定するディレクトリは/として認識されます。この値を設定する場合は非常に注意してください。デフォルトでは空です。）
    overlay_directory=
    # カスタムリポジトリのディレクトリ（このディレクトリ直下に必ずアーキテクチャ別のディレクトリを作成し、その中に*.pkg.tar.xzを配置してください。指定したパッケージをインストールする場合は必ずadd_pkgでパッケージ名を指定してください。）
    customrepo_directory=
}


# 変数設定
year=`date "+%Y"`
month=`date "+%m"`
day=`date "+%d"`
current_scriput_path=$(realpath "$0")
current_scriput_dir=$(pwd)
number_of_pkg=${#add_pkg[*]}


# 設定読み込み
if [[ ! -f $settings_path || -z $settings_path ]]; then
    settings
else
    source $settings_path
    check_import=$?
    if [[ ! $check_import = 0 ]]; then
        settings
    fi
fi


## 関数定義
function red_log () {
    echo -e "\033[0;31m$@\033[0;39m" >&2
    return 0
}

function blue_log () {
    if [[ ! $bluelog = 1 ]]; then
    echo -e "\033[0;34m$@\033[0;39m"
    fi
    return 0
}

function yellow_log () {
    echo -e "\033[0;33m$@\033[0;39m" >&2
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


## Rootチェック
if [[ ! $UID = 0 ]]; then
    red_log "You need root permission."
    exit 1
fi


## ディストリビューションチェック
if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    if [[ ! $ID = "arch" ]]; then
        red_log "The script is able to run in ArchLinux only."
        exit 1
    fi
else
    red_log "There is not /etc/os-release."
    exit 1
fi


## 出力先チェック
if [[ -f $image_file_path ]]; then
    red_log "A file with the same name exists."
    exit 1
fi


## アーキテクチャチェック
case $make_arch in
    i686 ) : ;;
    x86_64 ) : ;;
    * ) red_log "This architecture is illegal." 
        exit 1 ;;
esac


## ユーザーチェック
if [[ ! $(user_check $user ) = 0 ]]; then
    red_log "User $user is not exist."
    exit 1
fi


## ArchISOインストール、アップグレード
if [[ -z $remote_archiso_version ]]; then
    remote_archiso_version=$(pacman -Ss  $archiso_package_name  | awk '{print $2}' | head -n 1)
fi
if [[ -z $local_archiso_version ]]; then
    local_archiso_version=$(pacman -Q | grep " $archiso_package_name" | awk '{print $2}')
fi

if [[ $(package_check $archiso_package_name ; printf $?) = 1 ]]; then
    yellow_log "ArchISO is not installed."
    yellow_log "Install ArchISO."
    if [[ $archiso_package_name = "archiso" ]]; then
        pacman -Syy --noconfirm
        pacman -S --noconfirm archiso
    else
        red_log "手動で$archiso_package_nameをインストールしてください。"
        exit 1
    fi
elif [[ $local_archiso_version < $remote_archiso_version ]]; then
    yellow_log "ArchISO is installed."
    yellow_log "But ArchISO is older."
    yellow_log "Upgrade ArchISO."
    yellow_log "Installed  version: $local_archiso_version"
    yellow_log "Repository version: $remote_archiso_version"
    if [[ $archiso_package_name = "archiso" ]]; then
        pacman -Syy --noconfirm
        pacman -S --noconfirm archiso
    else
        red_log "手動で$archiso_package_nameをインストールしてください。"
        exit 1
    fi
elif [[ $local_archiso_version > $remote_archiso_version ]]; then
    yellow_log "Installed ArchISO is newer than official repository."
    yellow_log "Installed  version: $local_archiso_version"
    yellow_log "Repository version: $remote_archiso_version"
fi


## 作業ディレクトリ作成
if [[ ! -d $working_directory ]]; then
    mkdir -p $working_directory
    chmod 755 $working_directory
else
    if [[ -z $query ]];  then
        yn=$query
    else
        printf "Working directory already exists. Do you want to initialize it? :"
        read yn
    fi
    function del () {
        blue_log "作業ディレクトリを削除しています。"
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
blue_log "作業ディレクトリをコピーしています。"
    cp -r $archiso_configs/* $working_directory
    if [[ $make_arch = "i686" ]]; then
        if [[ ! -f $i686_build_script ]]; then
            red_log "i686's build.sh is not exist."
            exit 1
        else
            rm $working_directory/build.sh
            cp $i686_build_script $working_directory/build.sh
        fi
    fi
else
    red_log "There is not ArchISO profiles."
    if [[ $archiso_configs = "/usr/share/archiso/configs/releng/" ]]; then
        red_log "Please Install ArchISO."
    else
        red_log "Please check setting "archiso_configs""
    fi
    exit 1
fi


## カスタムパッケージの追記
blue_log "カスタムパッケージをリストに追加しています..."
for (( i=0; i<number_of_pkg ; i++ )); do
    echo ${add_pkg[$i]} >> $working_directory/package.$make_arch
done 


## Grub背景の置き換え
if [[ -n $grub_background ]]; then
    if [[ ! -f $grub_background ]]; then
        red_log "Grub背景へのパスが正しくありません。"
        exit 1
    fi
    cp $grub_background $working_directory/syslinux/splash.png
fi


## オーバーレイディレクトリのコピー
if [[ -n $overlay_directory ]]; then
    if [[ ! -d $overlay_directory ]]; then
        red_log "オーバーレイディレクトリの設定が不正です。"
        exit 0
    fi
    blue_log "オーバーレイディレクトリをコピーしています..."
    cp -ri $overlay_directory $working_directory/airootfs
fi


## カスタムリポジトリの追加
if [[ -n $customrepo_directory  ]]; then
    if [[ ! -d $customrepo_directory ]]; then
        red_log "カスタムリポジトリのディレクトリが存在しません。"
        exit 1
    fi
    if [[ ! -d $customrepo_directory/$make_arch ]]; then
        red_log "アーキテクチャ別のカスタムリポジトリのディレクトリが存在しません。"
        red_log "$customrepo_directory直下にアーキテクチャ別のディレクトリを作成して、その中にpkg.tar.xzを入れてください。"
        exit 1
    fi
    cd $customrepo_directory/$make_arch
    "パッケージリストを生成します。"
    repo-add customrepo.db.tar.gz *.pkg.tar.xz
    cd $current_scriput_dir
    blue_log "カスタムパッケージを登録します。"
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
    red_log "The image file that should have existed does not exist."
    red_log "Please run the script again."
    exit 1
fi
mv $working_directory/out/* $image_file_path


## 権限変更
blue_log "イメージファイルの権限を変更します。"
if [[ -z $group ]]; then
    group=wheel
fi
chown $user:$group  $image_file_path
chmod $perm $image_file_path


## 作業ディレクトリ削除
if [[ -d $working_directory ]]; then
    blue_log "作業ディレクトリを削除しています。"
    rm -rf $working_directory
else
    red_log "$working_directory is not found."
fi


## 作成後メッセージ
if [[ -f $image_file_path ]]; then
    blue_log "Created ArchLinux Live CD in $image_file_path"
else
    red_log "The image file could not be moved."
    red_log "The file may be in $working_directory/out/ ."
    exit 1
fi
