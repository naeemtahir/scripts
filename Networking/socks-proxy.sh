#!/bin/sh

if [ "$#" -ge 2 ]; then
    SSH_USER=$1
    SSH_HOST=$2
    SSH_PORT=${3:-22}

    echo "Opening SSH tunnel to ${SSH_USER}@${SSH_HOST}:${SSH_PORT}.        "
    echo "=================================================================="
    echo "Please configure your browser's SOCKS v5 proxy to: 127.0.0.1:8080 "
    echo "Enable 'Proxy DNS when using SOCKS' to prevent DNS leaks.         "
    echo "Also consider disabling WebRTC and other proxy extensions.        "
    echo "=================================================================="
    echo "Press Ctrl-C to close the tunnel.                                 "
    echo "                                                                  "

    ssh -p $SSH_PORT $SSH_USER@$SSH_HOST -D 8080 -C -N
else
    script_name=$(basename "$0")
    echo "Usage: $script_name <ssh-user> <ssh-host> [ssh-port; default=22]"
    exit 1
fi
