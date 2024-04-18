#!/bin/sh

# Embeds signature in lower-left corner of images

FONT="/Library/Fonts/Arial Narrow Bold Italic.ttf"
NAME='Naeem Tahir'

OLD_IFS="$IFS"
IFS=$'\n'
for file in `find . -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.gif" \)`; do
	mogrify -font $FONT -pointsize 20 -verbose -draw "gravity southwest fill black text 14,15 '$NAME' fill white text 15,15 '$NAME' " "$file";
done
IFS="$OLD_IFS"	
