#!/bin/sh

if [ "$#" -eq 3 ]; then
    echo "==============================================================================="
    echo "Opening tunnel, please set Socks proxy to '127.0.0.1:8080' in your browser  (use Socks v5)"
    echo "Check out for stopping DNS Leak while on SSH: http://www.adamburvill.com/2014/03/ssh-socks-tunnelling-and-avoiding-dns.html"
    echo "==============================================================================="
    
    USER=$1
    HOST=$2
    SSH_PORT=$3

    ssh $USER@$HOST -p $SSH_PORT -D 8080 -C -N

else
    script_name=`basename "$0"`
    echo "Usage: $script_name <user> <host> <ssh_port>"
    exit 1
fi

