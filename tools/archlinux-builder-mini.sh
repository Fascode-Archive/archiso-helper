#!/usr/bin/env bash

## 変数定義
function settings () {
    ## 作業ディレクトリ
    # このディレクトリ内に設定ファイル等を作成するため空のディレクトリを指定することをおすすめします。
    #~/などを指定するのはその中に大量のファイルを展開されてしまう恐れがあるためおすすめしません。
    # 最後に/を入れないでください
    working_directory="/tmp/archiso-helper"

    ## 作成後のイメージファイルのパス
    # フルパスで表記してください。それぞれ${yaer}、${month}、${day}で年、月、日に置き換えることができます。
    # ここの値が不正な場合、失敗するか作業ディレクトリ/outに作成されます。
    image_file_path="/root/archlinux-${year}.${month}.${day}-x86_64.iso"
}


## 関数定義
# 赤（エラー時）
function red_log () {
    echo -e "\033[0;31m$@\033[0;39m" >&2
    if [[ -d $working_directory ]]; then
        rm -rf $working_directory
    fi
    exit 1
}

# 青（通常のログ）
function blue_log () {
    echo -e "\033[0;34m$@\033[0;39m"
}

# 黄（注意、デバッグ）
function yellow_log () {
    echo -e "\033[0;33m$@\033[0;39m" >&2
}

# パッケージがインストールされているか（終了コード0ならインストールされている、1ならされていない）
function package_check () {
    if [[ -n $( pacman -Q $1 | awk '{print $1}' ) ]]; then
        return 0
    else
        return 1
    fi
}

# パッケージのインストール
function install_pacman () {
    pacman -Syy --noconfirm
    pacman -S --noconfirm $@
}

function ans () {
    case $yn in
        y ) del ;;
        Y ) del ;;
        Yes ) del ;;
        yes ) del ;;
        * ) red_log "終了します。" ;;
    esac
    unset yn
}


## タイトル

cat <<EOF
===================================
ArchLinux ISO Auto Builder
Mail: shun819.mail@gmail.com
Twitter : @Hayao0819
===================================
EOF


## 設定
year=$(date "+%Y")
month=$(date "+%m")
day=$(date "+%d")
settings


## ネット接続確認
blue_log "インターネット接続をチェックしています。"
if [[ ! $(ping "google.com"  -c 1 >> /dev/null ; echo $?) = 0 ]]; then
    red_log "インターネットに接続されていません。"
else
    blue_log "ネットワークに接続されています。"
fi


## Rootチェック
if [[ ! $UID = 0 ]]; then
    red_log "Root権限で実行してください。"
fi


## ディストリビューションチェック
if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    if [[ ! $ID = "arch" ]]; then
        red_log "このスクリプトはArchLinux専用です。"
    fi
else
    red_log "/etc/os-releaseが見つかりませんでした。"
fi


## 作業ディレクトリチェック
if [[ $(pwd) = $working_directory ]]; then
    red_log "作業ディレクトリにスクリプトの存在しているディレクトリを指定することはできません。"
fi


## 出力先チェック
if [[ -f $image_file_path ]]; then
    printf "$image_file_pathが既に存在しています。上書きしてもよろしいですか？ (y/N) : "
    read yn
    function del () {
        rm $image_file_path
    }
    ans
fi


## ArchISOインストール、アップグレード
if [[ $(package_check archiso; printf $?) = 1 ]]; then
    yellow_log "archisoをインストールします"
    install_pacman archiso
fi


## 作業ディレクトリ作成
if [[ -d $working_directory ]]; then
    printf "作業ディレクトリはすでに存在しています。削除してもよろしいですか？ : "
    read yn
    function del () {
        blue_log $log_delete_working_dir
        rm -rf $working_directory
    }
    ans
fi
mkdir -p $working_directory
mkdir -p $working_directory/out/
chmod 755 -R $working_directory


## ArchISOプロファイルコピー
if [[ -d /usr/share/archiso/configs/releng ]]; then
    blue_log "設定ファイルをコピーしています。"
    cp -r /usr/share/archiso/configs/releng/* $working_directory
else
    red_log "設定ファイルが見つかりませんでした"
fi


## ISO作成
blue_log "ビルドを開始します。"
cd $working_directory
$working_directory/build.sh -v
cd - > /dev/null
if [[ ! $? = 0 ]]; then
    red_log "何らかのエラーでビルドが失敗しました。"
fi


## イメージファイル移動
if [[ -z $( ls $working_directory/out ) ]]; then
    red_log "イメージファイルが見つかりませんでした。スクリプトを再実行してください。"
fi
mv $working_directory/out/* $image_file_path


## MD5
if [[ $(package_check md5; printf $?) = 1 ]]; then
    yellow_log "MD5ファイルを生成するには、MD5パッケージをAURからインストールしてください。"
else
    md5 $image_file_path  > "$(basename $image_file_path).md5"
fi


## 作業ディレクトリ削除
if [[ -d $working_directory ]]; then
    blue_log "作業ディレクトリを削除しています..."
    rm -rf $working_directory
else
    yellow_log "作業ディレクトリが見つかりませんでした。"
fi


## 作成後メッセージ
if [[ -f $image_file_path ]]; then
    blue_log "イメージファイルは$image_file_pathに作成されました。"
else
    red_log "イメージファイルの移動に失敗しました。イメージファイルは$working_directory/outに残っている可能性があります。"
fi