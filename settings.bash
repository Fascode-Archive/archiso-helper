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