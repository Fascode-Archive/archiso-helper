#!/usr/bin/env bash

if [[ $current_scriput_dir = $working_directory ]]; then
    red_log $error_working_dir_script
    exit_error
fi