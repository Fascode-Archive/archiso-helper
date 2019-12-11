#!/usr/bin/env bash

if [[ $create_md5 = 0 ]]; then
    cd $out_dir
    md5sum $image_file_path  > $out_name.md5
    cd - > /dev/null
fi