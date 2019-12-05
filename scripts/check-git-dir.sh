#!/usr/bin/env bash

if [[ $clone_temp = $working_directory ]]; then
    red_log $error_working_dir_git
    exit_error
fi