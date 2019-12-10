#!/usr/bin/env bash

#
if [[ -z $( ls $working_directory/out ) ]]; then
    red_log $error_image_not_found
    red_log $error_run_again
    exit_error
fi
mv $working_directory/out/* $image_file_path