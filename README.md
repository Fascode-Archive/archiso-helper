# archlinux-latest-livecd-builder
ArchLinuxの最新のライブCDをビルドします   

# 実行方法
デフォルトでは/home/直下にarchlinux-hogehoge-x86_64.isoで作成されます。

```bash
wget -q https://raw.githubusercontent.com/Hayao0819/archlinux-latest-livecd-builder/master/archlinux-builder.sh
wget -q https://raw.githubusercontent.com/Hayao0819/archlinux-latest-livecd-builder/master/build_i686.sh
chmod 755 archlinux-builder.sh
sudo ./archlinux-builder.sh
```

# 設定
スクリプト内で設定を変更できます（変数の値を変更してください。）  
以下はスクリプト内での設定の解説です。


## working_directory
作業ディレクトリです。デフォルトでは/home/arch-buoldになっています。  
このディレクトリにArchISOのプロファイルをコピーします。  

```bash
working_directory="/home/arch-build"
```

## image_file_path
ライブCDの保存先です。必ずフルパスで記述してください。  
それぞれ${yaer}、${month}、${day}で年、月、日に置き換えることができます。

```bash
image_file_path="/home/archlinux-${year}.${month}.${day}-x86_64.iso"
```

## make_arch
作成するLiveCDのアーキテクチャです。i686もしくはx86_64で指定してください。

```bash
make_arck=x86_64
```

## archiso_package_name
archisoのパッケージ名です。archiso-gitを利用する場合などに設定してください。

```bash
archiso_package_name="archiso"
```


## aur_helper
pacmanと同じ構文のAURHelperを使用する際に変更してください（archiso-gitを使用するためにyayに変更するなど）

```bash
aur_helper="pacman"
```


