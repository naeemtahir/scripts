#!/bin/bash

# https://misc.flogisoft.com/bash/tip_colors_and_formatting
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
NO_COLOR='\e[0m'
LIGHT_CYAN='\e[96m'
WHITE='\e[97m'
BLINK='\e[5m'

if [ -z "$TODO" ]; then
    echo -e "${RED}Environment variable TODO not defined.${NO_COLOR}"
    exit 1
fi

if [ ! -f "$TODO" ]; then
    echo -e "${RED}File not found: ${TODO}${NO_COLOR}"
    exit 1
fi

if [ "$#" -ge 1 ]; then
    if [ "$1" == "-e" ] || [ "$1" == "-g" ]; then
        if [[ "$OSTYPE" == "linux"* ]] && ([[ $(uname -a) =~ .*Microsoft.* ]] || [[ $(uname -a) =~ .*WSL2.* ]]); then
            vi "$TODO"
        elif [[ "$OSTYPE" == "linux"* ]]; then
            if [ "$1" == "-g" ]; then
                xdg-open "$TODO" &
            else
                vi "$TODO"
            fi
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            if [ "$1" == "-g" ]; then
                open "$TODO" &
            else
                vi "$TODO"
            fi
        else
            vi "$TODO"
        fi
    else
        script_name=$(basename "$0")
        echo "View or edit (use -e) your TODOs file (i.e., $TODO)."
        echo "  Usage: $script_name [-e] [-g]"
        echo "      -e Edit TODOs in vi"
        echo "      -g Edit TODOs in default Graphics editor"
    fi
else
    echo -e "${GREEN} _____ ___  ____   ___       ${NO_COLOR}"
    echo -e "${GREEN}|_   _/ _ \|  _ \ / _ \ ___  ${NO_COLOR}"
    echo -e "${GREEN}  | || | | | | | | | | / __| ${NO_COLOR}"
    echo -e "${GREEN}  | || |_| | |_| | |_| \__ \ ${NO_COLOR}"
    echo -e "${GREEN}  |_| \___/|____/ \___/|___/ ${NO_COLOR}"
    echo ""
    cat "$TODO"
    echo ""
    echo -e "${LIGHT_CYAN}Pass -e or -g to edit TODOs${NO_COLOR}"
fi
