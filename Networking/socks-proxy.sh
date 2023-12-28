#!/bin/sh

if [ "$#" -eq 2 ]; then
    echo "==============================================================================="
    echo "Opening tunnel, please set SOCKS v5 proxy to '127.0.0.1:8080' in your client."
    echo "Prevent DNS Leak while on SSH -> http://www.adamburvill.com/2014/03/ssh-socks-tunnelling-and-avoiding-dns.html"
    echo "==============================================================================="

    ssh $1@$2 -D 8080 -C -N
else
    script_name=$(basename "$0")
    echo "Usage: $script_name <user> <host>"
    exit 1
fi
