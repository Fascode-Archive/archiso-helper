#!/usr/bin/env bash

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

    ## archisoの設定プロファイルへのパス
    #ここにGitのリポジトリを指定することも可能です（ベータ機能）
    # Gitで指定する場合はリポジトリ直下にプロファイルを作成する必要があります
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

settings