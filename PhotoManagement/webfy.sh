#!/bin/bash

re='^[0-9]+$'

if [ "$#" -eq 2 ] && [[ $1 =~ $re ]] && [[ $2 =~ $re ]]; then
	width=$1
	counter=$2
	prefix=`cat /dev/urandom | tr -dc 'A-Z' | fold -w 4 | head -n 1`
	
	OLD_IFS="$IFS"
	IFS=$'\n'
	for file in `find . -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) | sort`; do
		fext="${file##*.}"
  
		mogrify -strip -auto-orient "$file"
		
		if [ "$width" -gt 0 ]; then
			mogrify -resize $width -verbose "$file"
		fi
		
		newname=`printf "%s_%06d" "$prefix" "$counter"`
		
		mv "$file" "$newname"."$fext"
		
		counter=$((counter+1));
	done
	IFS="$OLD_IFS"	
else
    script_name=`basename "$0"`
    echo "Strips EXIF data, shrinks to given width, and renames image files."
    echo "  Usage: $script_name <width (0 for no resize)> <file_counter>"
	exit 1
fi
