#!/bin/bash

# https://misc.flogisoft.com/bash/tip_colors_and_formatting
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
NO_COLOR='\e[0m'
LIGHT_CYAN='\e[96m'

if [ "$#" -eq 2 ] && ([[ "$1" == "-l" ]] || [[ "$1" == "-d" ]]) && [ -d "$2" ]; then
   PROFILE_DIR="$2"

   bookmarks=$(sqlite3 "$PROFILE_DIR"/places.sqlite "SELECT places.URL FROM moz_places as places JOIN moz_bookmarks as bookmarks ON places.id=bookmarks.fk order by places.URL")

   for b in $bookmarks; do
      http_header=$(curl -s -L -I --max-time 5 $b) # Follow redirects
      #http_header=$(curl -s -I --max-time 5 $b)  # Don't follow redirects
      exit_code=$?

      if [ "$exit_code" -eq "0" ]; then
         status_code=$(echo "$http_header" | grep HTTP | tail -1 | cut -d' ' -f 2)
         #echo "$status_code $b"

         if [ $status_code -ne 200 ] && [ $status_code -ne 301 ]; then
            if [ "$1" == "-d" ]; then
               echo -e "${RED}Deleting $b [$status_code]${NO_COLOR}"
               sqlite3 "$PROFILE_DIR"/places.sqlite "DELETE FROM moz_bookmarks WHERE id IN (SELECT bookmarks.id FROM moz_places as places JOIN moz_bookmarks as bookmarks ON places.id=bookmarks.fk where places.URL='$b')"
            fi
         fi
      elif [ "$exit_code" -eq "28" ]; then
         echo -e "${YELLOW}$b timed out${NO_COLOR}"
      else
         echo -e "${RED}Cannot query $b, exit code $exit_code. Check your network connection and try again.${NO_COLOR}"
         exit $exit_code
      fi
   done
else
    script_name=`basename "$0"`
    echo "Usage: $script_name <-l|-d> </path/to/profile>"
    echo "  -l, List dead bookmarks"
    echo "  -d, Delete dead bookmarks"

    exit 1
fi
