#!/usr/bin/env bash

if $create_md5; then
    cd $out_dir
    md5sum $out_path  > $out_name.md5
    cd - > /dev/null
fi