#!/bin/bash

re='^[0-9]+$'

set -e

if [ "$#" -ge 1 ] && [[ $1 =~ $re ]]; then
	counter=$1
	prefix=${2:-""} # If there's a second argument, assign it to the prefix variable; otherwise use empty string as default prefix

	OLD_IFS="$IFS"
	IFS=$'\n'
	for file in $(find . -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) | sort); do
    fext="${file##*.}"

    new_filename=$(printf "%s%04d.%s" "$prefix" "$counter" "$fext")
    mv -iv "$file" "$new_filename"

    counter=$((counter+1));
	done
	IFS="$OLD_IFS"
else
    script_name=$(basename "$0")
    echo "Renames photos starting with given counter value and optional prefix."
    echo "  Usage: $script_name <start_val> [prefix]"
    exit 1
fi
