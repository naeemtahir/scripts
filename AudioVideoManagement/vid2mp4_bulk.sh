#!/bin/bash

# Converts all MPG/3GP/WMV/AVI/MOV/M4V videos in current folder to MP4 format

GREEN='\e[32m'
NO_COLOR='\e[0m'

printf "${GREEN}Converting all MPG/3GP/WMV/AVI/MOV/M4V videos in current folder to MP4 format.${NO_COLOR}\n"

OLD_IFS="$IFS"
IFS=$'\n'
  newname=$(echo ${file} | sed 's/\.mpg/\.mp4/I; s/\.3gp/\.mp4/I; s/\.wmv/\.mp4/I; s/\.avi/\.mp4/I; s/\.mov/\.mp4/I; s/\.m4v/\.mp4/I')

  printf "${GREEN}Converting \"${file}\" => \"${newname}\"${NO_COLOR}\n"
	ffmpeg -i "${file}" "${newname}"
done
IFS="$OLD_IFS"
