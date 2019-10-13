# archlinux-latest-livecd-builder
ArchLinuxの最新のライブCDをビルドします   

# 実行方法
デフォルトでは/home/直下にarchlinux-hogehoge-x86_64.isoで作成されます。

```bash
wget -q https://raw.githubusercontent.com/Hayao0819/archlinux-latest-livecd-builder/master/archlinux-builder.sh
chmod 755 archlinux-builder.sh
sudo ./archlinux-builder.sh
```

# 追加のファイルについて
settings.bashやbuild_i686.shは必須ではありません。
archlinux-builder.bash単体でも利用可能です。

## settings.bash
設定を記述したファイルです。archlinux_builder.bashを更新した際に設定を保存できるファイルです。  
（更新によって設定項目が追加された場合、settings.bashに手動で追加する必要があります。）

## build_i686.sh
i686でビルドするためのスクリプトです。
直接実行せず、archlinux-builder.bashを経由して実行してください。
x86_64をビルドする場合は不要です。


# i686
32bit版を生成する場合は追加で以下のコマンドが必要です。  
（i686用のビルドスクリプトが必要なため）

```bash
wget -q https://raw.githubusercontent.com/Hayao0819/archlinux-latest-livecd-builder/master/build_i686.sh
```


# 設定
設定はsettings.bashで設定することが推奨されています。  
（スクリプト内で設定することも可能です。）
設定はスクリプト内に細かく書かれています。


