#!/usr/bin/env bash

script_dir=./scripts

# 初期値読み込み
source $script_dir/initial.sh

# スクリプトを実行
run () { source $@; }

# タイトル
run $script_dir/start.sh

# 設定
run $script_dir/load-settings.sh

# 言語チェック
run $script_dir/check-lang.sh

# 翻訳スクリプトのチェック
run $script_dir/install-translate-shell.sh

# ネット接続確認
run $script_dir/check-network.sh

# Rootチェック
run $script_dir/check-root.sh

# ディストリビューションチェック
run $script_dir/check-os.sh

# 作業ディレクトリチェック
run $script_dir/check-work-dir.sh

# Gitクローンディレクトリチェック
run $script_dir/check-git-dir.sh

# 出力先チェック
run $script_dir/check-image.sh

# ユーザーチェック
run $script_dir/check-user.sh

# Mirrorチェック
run $script_dir/check-mirror.sh

# デバッグ変数の表示
run $script_dir/show-debug.sh

# ArchISOインストール、アップグレード
run $script_dir/install-archiso.sh

# 作業ディレクトリ作成
run $script_dir/make-work-dir.sh

# プロファイルコピー
run $script_dir/copy-profiles.sh

# Grub背景の置き換え
run $script_dir/change-grub.sh

# オーバーレイディレクトリのコピー
run $script_dir/copy-overlay-dir.sh

# customize_airootfs.shのコピー
run $script_dir/copy-customize-script.sh

# 追加実行コマンド
run $script_dir/add-command.sh

# AURパッケージの追加
run $script_dir/add-aur-to-repo.sh

# カスタムリポジトリの追加
run $script_dir/add-custom-repo.sh

# 非公式リポジトリの追加
run $script_dir/add-unofficial-repo.sh

# パッケージの追記
run $script_dir/add-pkg.sh

# ビルドスクリプト設定
run $script_dir/set-build-script.sh

# ビルドスクリプト設定を元にビルド開始
run $script_dir/start-build.sh

# イメージファイル移動
run $script_dir/move-image.sh