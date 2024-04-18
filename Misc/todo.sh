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

if [ "$#" -ge 1 ]; then
    if [ "$1" == "-e" ]; then
        if [[ "$OSTYPE" == "linux"* ]] && [[ $(uname -a) =~ .*Microsoft.* ]]; then
            notepad.exe "$TODO" &
        elif [[ "$OSTYPE" == "linux"* ]]; then
            gedit "$TODO" &
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            open -a TextMate "$TODO" &
        else
            vi "$TODO"
        fi
    else
        script_name=$(basename "$0")
        echo "View or edit (use -e) your TODOs file (i.e., $TODO)."
        echo "  Usage: $script_name [-e]"
    fi
else
    cat "$TODO"
fi
