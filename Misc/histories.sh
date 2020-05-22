#!/bin/bash

# Disable all histories.

# Get list of all dot files: 'ls -CAF -1 | grep -v /''

declare -a hist_files=(
   "$HOME/.bash_history"
   "$HOME/.zsh_history"
   "$HOME/.python_history"
   "$HOME/.lesshst"
   "$HOME/.viminfo"
   "$HOME/.local/share/recently-used.xbel"
   "$HOME/.convertall"
)
   
for f in "${hist_files[@]}"
do
   rm $f && touch $f && chmod 400 $f
   ls -alF $f
done
