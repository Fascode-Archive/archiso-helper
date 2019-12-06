#!/usrbin/env bash

message_file="./locale/$msg_launguage.conf"

if [[ ! -f $message_file ]]; then
    msg_launguage="en"
fi

source $msg_launguage
