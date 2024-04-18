#!/bin/bash

echo "Cleaning up crap files and directories"

declare -a files=("$HOME/.cache/lxsession/LXDE/run.log" "$HOME/.xsel.log")
declare -a thumbnails=("$HOME/.cache/thumbnails" "$HOME/.thumbnails")

# Clear files
for f in "${files[@]}"
do
    if [ -f "$f" ]; then
        echo "Clearing $f"
        cat /dev/null > "$f"
    else 
        echo "$f does not exist, skipping"
    fi
done

# Clear thumbnails
for t in "${thumbnails[@]}"
do
    if [ -d "$t" ]; then
        echo "Cleaning $t"
        cd "$t" && find . -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.gif" \) -delete
    else
        echo "$t does not exist, skipping"
    fi
done

# Cleanup Mac Crap (usually reated when you access a shared folder from MacOS), and any Dropbox conflicts 
echo "Removing any .DS_Store, ._*, and *conflicted*"
find . -name "._*" -delete -o -name ".DS_Store" -delete -o -name "*conflicted*" -delete

# Finally cleanup current directoy with 'dot_clean' when on Mac
if [[ "$OSTYPE" == "darwin"* ]]; then
    dot_clean -m .  
fi

