#!/bin/bash

if [ "$#" -ge 2 ]; then
    touch -a -m -t $1 "${@:2}"
else
    script_name=`basename "$0"`
    echo "Usage: $script_name <Time, format: YYYYMMDDhhmm.SS> <file(s)>"
    exit 1
fi

