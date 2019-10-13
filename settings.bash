#!/usr/bin/env bash

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
    # 所有グループ名（作成後のISOイメージファイルの所有グループ）
    group=
    # 作成後のファイル権限
    perm=664

# archisoのパッケージ名です。(AURのパッケージ名にする場合はAURHelperを有効化してください。)
archiso_package_name="archiso"
# AURHelperの使用を強制する場合にのみpacmanから変更してください。もし存在しないAURHelperが入力された場合はpacmanが使用されます。また、AURHelperはpacmanと同じ構文のもののみ利用可能です。
aur_helper="pacman" 
# メッセージの出力（0=有効 1=無効 それ以外=有効）
bluelog=0 
# これらの値を変更するとArchISOのバージョン判定が正常に行えなくなります。ArchISOのバージョンを固定する場合にのみ、両方の値を変更してください。（両方の値は必ず一致させてください。）
local_archiso_version=
remote_archiso_version= 
# i686用ビルドスクリプトへのパス
i686_build_script=$current_scriput_dir/build_i686.sh
# archisoの設定プロファイルへのパス
archiso_configs="/usr/share/archiso/configs/releng"