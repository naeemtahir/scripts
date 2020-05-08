#!/bin/bash

if [ "$#" -eq 1 ] && ([[ "$1" == "f" ]] || [[ "$1" == "d" ]]); then
    if [ "$1" == "f" ]; then
        read -p "THIS WILL REPLACE '&' IN ALL FILE NAMES IN THIS DIRECTORY WITH 'and', CONTINUE... (y/n)? " -n 1 -r
    else
        read -p "THIS WILL REPLACE '&' IN ALL DIRECTORY NAMES IN THIS DIRECTORY WITH 'and', CONTINUE... (y/n)? " -n 1 -r
    fi
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        echo ""
        exit 1
    fi
    echo ""

    OLD_IFS="$IFS"
    IFS=$'\n'
    for file in `find . -type $1 -name "*&*"`; do
        newname=$(echo ${file} | sed 's/\&/and/g')
        echo "Renaming '$file' => '$newname'"
        mv "$file" "$newname"
    done
    IFS="$OLD_IFS"
else
    script_name=`basename "$0"`
    echo "Usage: $script_name <f|d>"
    echo "  f, Find and replace files containing &"
    echo "  d, Find and replace directories containing &"
    exit 1
fi

