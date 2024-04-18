#!/bin/sh

if [ "$#" -eq 4 ]; then
    REMOTE_USER=$1
    REMOTE_HOST=$2
    SERVICE_PORT=$3
    LOCAL_PORT=$4

    echo "Forwarding local port $LOCAL_PORT to $REMOTE_USER@$REMOTE_HOST. Access remote service on localhost:$LOCAL_PORT"

    ssh -L $LOCAL_PORT:localhost:$SERVICE_PORT $REMOTE_USER@$REMOTE_HOST -N
else
    script_name=$(basename "$0")
    echo "Access remote service on local_port"
    echo "  Usage: $script_name <remote_user> <remote_host> <remote_service_port> <local_port>"
    exit 1
fi
