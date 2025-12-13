#!/bin/bash

# Embeds signature in lower-left corner of images

FONT="/Library/Fonts/Arial Narrow Bold Italic.ttf"
NAME='Naeem Tahir'

prompt() {
    local msg="$*"

    if [[ $QUIET_MODE == 1 ]]; then
        return 0
    fi

    yesno="null"

    shopt -s nocasematch
    while [[ ! ${yesno} =~ ^([yn]|yes|no)?$ ]]; do
       read -r -p "$msg" yesno
    done
    shopt -s nocasematch

    if [[ $yesno =~ ^[Yy].* ]]; then
       return 0
    else
       # [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
       return 1
    fi
}

prompt "Proceeding will add signature to all image files in current folder. This action is irreversible. Do you want to continue? "
if [ "$?" -eq "1" ]; then
		return
fi

OLD_IFS="$IFS"
IFS=$'\n'
for file in `find . -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \)`; do
	mogrify -font $FONT -pointsize 20 -verbose -draw "gravity southwest fill black text 14,15 '$NAME' fill white text 15,15 '$NAME' " "$file";
done
IFS="$OLD_IFS"
