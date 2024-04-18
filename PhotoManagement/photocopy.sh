#!/bin/bash

# Scans for photos containing given file pattern, copies them to output_dir, and resizes to $SIZE. Set last argument to -n to prevent resizing.

SIZE=1024

if [ "$#" -ge 3 ]; then
	output_dir=${1%/}    # Remove trailing / if present

	if ! [ -d "$output_dir" ]; then
		echo "Creating folder $output_dir"
		mkdir -p "$output_dir"
	fi

	OLD_IFS="$IFS"
	IFS=$'\n'
	for file in `find . -iname "*$2*" -type f`; do
		dest_name=$(echo ${file:2} | sed 's/[\/ ]/_/g') # Ignore './' in the beginning, replace all occurances of '/' and ' ' in qualified path with '_'
		dest_path="$output_dir/$dest_name"
	
		if ! [[ -f "$dest_path" ]]; then
			echo "Copying $file => $dest_path";
			cp "$file" "$dest_path"
			
			if [ $? -eq 0 ] && [ "$3" != "-n" ]; then
				echo "Stripping EXIF data and resizing to $SIZE"
				mogrify -strip -resize $SIZE -auto-orient "$dest_path"
			fi
		fi
	done
	IFS="$OLD_IFS"
else
    script_name=`basename "$0"`
	echo "Scans for photos containing given pattern in the name, copies them to output_dir, and resizes to $SIZE. Set last argument to -n to prevent resizing."
    echo "Usage: $script_name <output_dir> <pattern_to_match, e.g., frame, print> <-y|-n>"
	exit 1
fi
