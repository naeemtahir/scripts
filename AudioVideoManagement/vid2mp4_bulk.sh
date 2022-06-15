#!/bin/bash

# Converts all MPG/3GP/WMV/AVI/MOV/M4V videos in current folder to MP4 format

GREEN='\e[32m'
NO_COLOR='\e[0m'

echo -e "${GREEN}Converting all MPG/3GP/WMV/AVI/MOV/M4V videos in current folder to MP4 format.${NO_COLOR}"

OLD_IFS="$IFS"
IFS=$'\n'
for file in `find . -maxdepth 1 -type f \( -iname "*.mpg" -o -iname "*.3gp" -o -iname "*.wmv" -o -iname "*.avi" -o -iname "*.mov"  -o -iname "*.m4v" \)`; do
  newname=$(echo ${file} | sed 's/\.mpg/\.mp4/I; s/\.3gp/\.mp4/I; s/\.wmv/\.mp4/I; s/\.avi/\.mp4/I; s/\.mov/\.mp4/I; s/\.m4v/\.mp4/I')

  echo -e "${GREEN}Converting \"${file}\" => \"${newname}\"${NO_COLOR}"
	ffmpeg -i "${file}" "${newname}"
done
IFS="$OLD_IFS"
