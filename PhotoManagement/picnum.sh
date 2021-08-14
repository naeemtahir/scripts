#!/bin/bash

re='^[0-9]+$'

if [ "$#" -ge 1 ] && [[ $1 =~ $re ]]; then
	counter=$1
	prefix=$2
	
	if [ -z "$prefix" ]; then
		prefix=`cat /dev/urandom | tr -dc 'A-Z' | fold -w 4 | head -n 1`
		prefix="${prefix}_"
		echo "No prefix supplied, using random prefix $prefix"
	fi

	OLD_IFS="$IFS"
	IFS=$'\n'
	for file in `find . -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) | sort`; do
    	fext="${file##*.}"
  
		newname=`printf "%s%04d" "$prefix" "$counter"`
        mv "$file" "$newname"."$fext"
		
        counter=$((counter+1));
	done
	IFS="$OLD_IFS"	
else
    script_name=`basename "$0"`
    echo "Renames photos starting with given counter value and optional prefix."
    echo "  Usage: $script_name <start_val> [prefix]"
	exit 1
fi
