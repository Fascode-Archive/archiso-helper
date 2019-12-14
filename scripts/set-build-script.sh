#!/usr/bin/env bash

function build () {
    # enable build
    export verbose="-v"

    if [[ -z $iso_label ]]; then
        export iso_label="ARCH_$(date +%Y%m%d)"
    fi
    if [[ -z $iso_publisher ]]; then
        export iso_publisher="Arch Linux <http://www.archlinux.org>"
    fi
        
    # build.sh
    run $script_dir/archiso-build.sh
}
if [[ -n $custom_build_script && -f $custom_build_script ]]; then
    export build_script=$custom_build_script
elif [[ ! $arch = "x86_64" ]]; then
    export build_script="$working_directory/build.sh"
elif [[ -f $working_directory/build.sh ]]; then
    if [[ -n $query ]];  then
        yn=$query
    else
        echo  "プロファイルのbuild.shが見つかりました。プロファイルのbuild.shを使用しますか?（y/N）"
        printf "プロファイルのbuild.shを使用しない場合は 内臓のビルドスクリプト（x86_64のみ）が使用されます。: "
        read yn
    fi

    case $yn in
        y ) export build_script="$working_directory/build.sh" ;;
        Y ) export build_script="$working_directory/build.sh" ;;
        Yes ) export build_script="$working_directory/build.sh" ;;
        yes ) export build_script="$working_directory/build.sh" ;;
        * ) export build_script="include" ;;
    esac
    unset yn
else
    export build_script="include"
fi