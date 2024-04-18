#!/bin/bash
set -e

download_audio() {
    local arg=$*

    echo $arg
    youtube-dl -x --audio-format mp3 --output "%(title)s.%(ext)s" $arg
}

if [ "$#" -eq 1 ]; then
    while IFS= read -r line; 
    do
        download_audio $line
    done < $1    
else
    script_name=$(basename "$0")
    echo "Usage: $script_name <input file containing links (one link per line)>"
    exit 1
fi
