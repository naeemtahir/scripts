#!/bin/sh

if [ "$#" -eq 5 ]; then
    GATEWAY_USER=$1
    GATEWAY_HOST=$2
    TARGET_HOST=$3
    TARGET_PORT=$4
    LOCAL_PORT=$5

    echo "Forwarding local port $LOCAL_PORT to $TARGET_HOST:$TARGET_PORT via $GATEWAY_HOST. Access remote service on localhost:$LOCAL_PORT"
    
    ssh -L $LOCAL_PORT:$TARGET_HOST:$TARGET_PORT $GATEWAY_USER@$GATEWAY_HOST -N
else
    script_name=`basename "$0"`
    echo "Access remote service on local port"
    echo "  usage: $script_name <gateway_user> <gateway_host> <target_host> <target_port> <local_port>"
    exit 1
fi
