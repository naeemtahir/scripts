#!/bin/bash

PERM_HOSTNAME=$(grep '127\.0\.1\.1' /etc/hosts | cut -f2)
RAND_HOSTNAME=$(strings /dev/urandom | grep -o '[[:lower:]]' | head -n 8 | tr -d '\n')

if [ "$#" -eq 1 ] && ([[ "$1" == "-r" ]] || [[ "$1" == "-p" ]]); then
    sudo service NetworkManager stop
    
#    for i in `ip link | awk -F: '$0 !~ "lo|vir|vbox|^[^0-9]" {print $2;getline}'`
    for i in `ls /sys/class/net | awk '$1 !~ "lo|vbox|vir" {print $1;getline}'`; do
        printf "\n[$i]\n"
        sudo ip link set dev $i down
        sudo macchanger $1 $i
        sudo ip link set dev $i up
    done

    if [ "$1" == "-r" ]; then
        sudo hostnamectl set-hostname $RAND_HOSTNAME
    else
        sudo hostnamectl set-hostname $PERM_HOSTNAME
    fi

    echo
    echo -n "Hostname: "
    hostname
    
    sudo service NetworkManager start
else
    script_name=`basename "$0"`
    echo "Usage: $script_name <-r|-p>"
    echo "  -r, set random MAC and hostname"
    echo "  -p, set original MAC and hostname"
    exit 1
fi

