#!/bin/bash

# https://misc.flogisoft.com/bash/tip_colors_and_formatting
RED='\e[31m'

if [ -z "$TODO" ]; then
    echo -e "${RED}Environment variable TODO not defined.${NO_COLOR}"
    exit 1
fi

if [ ! -f "$TODO" ]; then
    echo -e "${RED}File not found: ${TODO}${NO_COLOR}"
    exit 1
fi

if [ "$#" -gt 0 ]; then
    echo "[] $@" >> $TODO
fi

cat $TODO
