#!/usr/bin/env bash


#-- 初期変数 定義 --#
year=$(date "+%Y")
month=$(date "+%m")
day=$(date "+%d")
current_scriput_path=$(cd $(dirname $0) && pwd)/$(basename $0)
current_scriput_dir=$(pwd)

#-- 設定ファイルへのパス --#
# 引数で指定されていた場合は上書きされます。引数が間違っていた場合はこの設定が使用されます。
settings_path=$(pwd)/config


#========================================================================================#
#-- 変数定義 --#
#もし設定ファイルに変数が存在しない場合はこの設定が上書きされます。

###############################################
# ディレクトリを指定する場合は最後に/を入れないでください。
###############################################


## 作業ディレクトリ
# このディレクトリ内に設定ファイル等を作成するため空のディレクトリを指定することをおすすめします。
#~/などを指定するのはその中に大量のファイルを展開されてしまう恐れがあるためおすすめしません。
working_directory="/tmp/archiso"


## 作成後のイメージファイルの名前
# それぞれ${yaer}、${month}、${day}で年、月、日に置き換えることができます。
# ここの値が不正な場合、失敗するか作業ディレクトリ/outに作成されます。
image_file_name="archlinux-${year}.${month}.${day}-x86_64.iso"


## 保存先のディレクトリ
# イメージファイルを保存するディレクトリです。
image_file_dir="/home"


## 追加する公式リポジトリのパッケージ
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


## MD5の作成（0=有効 1=無効 それ以外=無効）
create_md5=0

## sha256の作成（0=有効 1=無効 それ以外=無効）
create_sha256=0



###以下の設定は下手に変更すると重大な影響を及ぼします。必要な場合を除いて変更しないでください。



##ネットワークチェックのURL
#ドメインもしくはIPのみを入力してください。
check_url="google.com"


## archisoの設定プロファイルへのパス
archiso_configs="/usr/share/archiso/configs/releng"


## 作業ディレクトリを終了時に削除するかどうか
# デバッグ用です。 0=削除する 1=削除しない それ以外=削除する
delete_working_dir=


## 設定ファイル生成モード
# 0=有効 1=無効 それ以外=無効
no_build=
#========================================================================================#


#-- 関数定義 --#
# 赤（エラー時）
function red_log () {
    echo -e "\033[1;31m$@\033[0;39m" >&2
    return 0
}

# 青（通常のログ）
function blue_log () {
    echo -e "\033[1;36m$@\033[0;39m"
    return 0
}

# 黄（注意、デバッグ）
function yellow_log () {
    echo -e "\033[0;33m$@\033[0;39m" >&2
    return 0
}

# 白、タイトル等
function white_log () {
    echo $@
    return 0
}

# パッケージがインストールされているか（終了コード0ならインストールされている、1ならされていない）
function package_check () {
    if [[ -z $1 ]]; then
        red_log "パッケージ名を指定してください。詳細はarchiso-helper開発者に問い合わせてください。"
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
    if [[ -d $working_directory && ! $delete_working_dir = 1 ]]; then
        rm -rf $working_directory
    fi
    if [[ $auto_make_customrepo = 0 && -d $customrepo_directory ]]; then
        rm -r $customrepo_directory
    fi
    exit 1
}


#-- タイトル --#
white_log
white_log "==================================="
white_log "ArchISO Helper"
white_log "Mail: shun819.mail@gmail.com"
white_log "Twitter : @Hayao0819"
white_log "==================================="
white_log


#-- 設定 --#
# 読み込み
if [[ -n $1 && -f $1 ]]; then
    settings_path=$1
elif [[ -n $1 && ! -f $1 ]]; then
    red_log "The path to the configuration file is incorrect."
    exit 1
fi

source $settings_path

if [[ -z $settings_path ]]; then
    blue_log "Loaded settings $current_script_path"
else
    if [[ -f $settings_path ]]; then
        source $settings_path
        if [[ ! $? = 0 ]]; then
            blue_log "Loaded settings $current_script_path"
        else
            source $settings_path
            blue_log "Loaded settings $settings_path"
        fi
    else
        blue_log "Loaded settings $current_script_path"
    fi
fi


# 後変数
number_of_pkg=${#add_pkg[*]}
image_file_path=$image_file_dir/$image_file_name


#-- ネット接続確認 --#
blue_log "Checking network connection ..."
if [[ ! $(ping $check_url  -c 1 >> /dev/null ; printf $?) = 0 ]]; then
    red_log "There is no network connection."
    exit 1
else
    blue_log "The network connection was confirmed."
fi


#-- Rootチェック --#
if [[ ! $UID = 0 ]]; then
    red_log "Root権限が必要です。"
    exit 1
fi


#-- ディストリビューションチェック --#
if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    if [[ ! $ID = "arch" && ! $ID = "arch32" ]]; then
        red_log "ArchLinuxで実行してください。"
        exit_error
    fi
fi


#-- 作業ディレクトリチェック --#
if [[ $current_scriput_dir = $working_directory ]]; then
    red_log "このスクリプトのディレクトリを作業ディレクトリにすることはできません。"
    exit_error
fi



#-- 出力先チェック --#
if [[ -f $image_file_path ]]; then
    if [[ -n $query ]];  then
        yn=$query
    else
        echo -n "既に出力先のイメージファイルが存在します。削除しますか？"
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


#-- ユーザーチェック --#
if [[ ! $(user_check $user ) = 0 ]]; then
    red_log "ユーザーが存在しません。"
    exit_error
fi


#-- archisoチェック --#
if [[ $(package_check archiso; printf $?) = 1 ]]; then
    yellow_log "システム上にarchisoがインストールされていません。pacmanを使用してインストールします。"
    install_pacman archiso
fi


#-- 作業ディレクトリ作成 --#
if [[ ! -d $working_directory ]]; then
    mkdir -p $working_directory
    chmod 755 $working_directory
else
    if [[ -n $query ]];  then
        yn=$query
    else
        printf "作業ディレクトリが既に存在しています。削除しますか？"
        read yn
    fi
    function del () {
        blue_log "古い作業ディレクトリを削除しています。"
        rm -rf $working_directory
    }
    case $yn in
        y ) del ;;
        Y ) del ;;
        Yes ) del ;;
        yes ) del ;;
        * ) exit 1;;
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


#-- 設定ファイルコピー --#
if [[ -d $archiso_configs ]]; then
    blue_log "設定ファイルを作業ディレクトリにコピーしています。"
    cp -r $archiso_configs/* $working_directory
else
    red_log "設定ファイルが見つかりませんでした。"
    exit_error
fi
if [[ ! -f $working_directory/build.sh ]]; then
    red_log "build.shがありません"
    exit_error
fi


#-- 追加パッケージの追記 --#
blue_log "追加パッケージを設定ファイルに書き込んでいます。"
for (( i=0; i<number_of_pkg ; i++ )); do
    echo ${add_pkg[$i]} >> $working_directory/packages.x86_64
done


#-- ビルド開始 --#
build_script="$working_directory/build.sh"
if [[ $no_build = 0 ]]; then
    mv $working_directory $(dirname $image_file_path)
    exit 0
fi
blue_log "ビルドを開始します。"
cd $working_directory

chmod +x $build_script
bash $build_script -v

cd - > /dev/null
if [[ ! $? = 0 ]]; then
    red_log "ビルドに失敗しました。"
    exit_error
fi


#-- イメージファイル移動 --#
if [[ -z $( ls $working_directory/out ) ]]; then
    red_log "出力先に何もファイルがありません。ビルドが失敗した可能性が高いです。"
    red_log "もう一度スクリプトを実行し直してみてください。"
    exit_error
fi
mv $working_directory/out/* $image_file_path


#-- MD5 --#
blue_log "MD5チェックサムを生成しています。"
if [[ $create_md5 = 0 ]]; then
    cd $image_file_dir
    md5sum $image_file_path  > $image_file_name.md5
    cd - > /dev/null
fi


#-- SHA256 --#
blue_log "SHA256チェックサムを生成しています。"
if [[ $create_sha256 = 0 ]]; then
    cd $image_file_dir
    md5sum $image_file_path > $image_file_name.sha256
    cd - > /dev/null
fi


#-- 権限変更 --#
blue_log "生成したファイルの権限を変更します。"
[[ -z $user ]] && user=root
[[ -z $group ]] && group=wheel
chown $user:$group  $image_file_path
chmod $perm $image_file_path

if [[ $create_md5 = 0 ]]; then
    chown $user:$group  $image_file_path.md5
    chmod $perm $image_file_path.md5
fi

if [[ $create_sha256 = 0 ]]; then
    chown $user:$group  $image_file_path.sha256
    chmod $perm $image_file_path.sha256
fi


#-- 作業ディレクトリ削除 --#
if [[ -d $working_directory && ! $delete_working_dir = 1 ]]; then
    blue_log "作業ディレクトリを削除しています。"
    rm -rf $working_directory
else
    red_log "$working_directoryが見つかりませんでした。"
fi


#-- 作成後メッセージ --#
if [[ -f $image_file_path ]]; then
    blue_log "ArchLinuxのLiveCDは ${image_file_path}に作成されました。"
else
    red_log "イメージファイルの移動に失敗しました。 ${working_directory}/out/ に残っている可能性があります"
    exit_error
fi
