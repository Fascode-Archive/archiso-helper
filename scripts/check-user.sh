#!/usr/bin/env bash

if [[ ! $(user_check $user ) = 0 ]]; then
    red_log $error_user
    exit_error
fi