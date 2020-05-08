#!/bin/bash

# Disable all histories.

declare -a hist_files=("$HOME/.bash_history" "$HOME/.python_history" "$HOME/.lesshst" "$HOME/.local/share/recently-used.xbel")

for i in "${hist_files[@]}"
do
   touch $i && cat /dev/null > $i && chmod 400 $i
   ls --color=auto -alF $i
done

