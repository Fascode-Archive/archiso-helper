# archiso-builder
ArchISOの補助を行います。デフォルト設定で最新のLiveCDをビルドすることもできます。  
（もともとは最新のCDをビルドするためだったんだが...）

# 実行方法
デフォルトでは/home/直下にarchlinux-hogehoge-x86_64.isoで作成されます。

```bash
wget -q https://0e0.pw/bFSJ
chmod +x start_build.bash
./start_build.bash
```

# 追加のファイルについて
settings.bashやbuild_i686.shは必須ではありません。

## start_build.bash
このファイルはビルドする際のランチャーとなるものです。  
必要なファイルを自動でダウンロード、実行します。  
スクリプト内部では、設定ファイルへのURLを指定できます。  
実行するたびにダウンロードを行うので常に最新の状態で利用できます。　　

## message.bash
必須のファイルです。単体で実行した場合は自動でダウンロードされます。  
このファイルを編集することで言語を追加できます。  

## settings.bash
設定を記述したファイルです。archlinux_builder.bashを更新した際に設定を保存できるファイルです。  
引数として設定ファイルへのパスを指定することができます。  
~~（更新によって設定項目が追加された場合、settings.bashに手動で追加する必要があります。）~~  
`ce77b3c `以降は設定が存在しなかった場合はデフォルト設定が使用されます。

## build_i686.sh
i686でビルドするためのスクリプトです。
直接実行せず、archlinux-builder.bashを経由して実行してください。
x86_64をビルドする場合は不要です。

## aur.bash
AURにあるパッケージをビルドして、*.pkg.tar.xzにします。ビルドするには引数としてAURのリポジトリを指定してください。  
スクリプトと同じ階層にパッケージが作成されます。カスタムリポジトリを利用する際に利用できます。

```bash
./aur.bash hogehoge fugafuga
```


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


