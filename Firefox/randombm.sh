#!/bin/bash

re='^[0-9]+$'
COUNT=1

if [ "$#" -eq 2 ] && [ -d "$1" ] && [[ $2 =~ $re ]]; then
   PROFILE_DIR="$1"
   COUNT=$2

   if [ $COUNT -gt 10 ]; then
      COUNT=10
   fi

   # Use last bookmkarks backup
   #LATEST_BM_BACKUP=$(ls -tr "$PROFILE_DIR"/bookmarkbackups | xargs -n 1 basename | tail -1)
   #RANDOM_BOOKMARKS=$(lz4jsoncat "$PROFILE_DIR"/bookmarkbackups/$LATEST_BM_BACKUP | python -mjson.tool | grep '\"uri\"\: \"http' | sed 's/\"//g;s/uri\://;s/^[ \t]*//' | shuf -n $COUNT)

   # Use places.sqlite
   RANDOM_BOOKMARKS=$(sqlite3 "$PROFILE_DIR"/places.sqlite "SELECT places.URL FROM moz_places as places JOIN moz_bookmarks as bookmarks ON places.id=bookmarks.fk order by RANDOM() limit $COUNT")

   echo $RANDOM_BOOKMARKS
else
    script_name=`basename "$0"`
    echo "Usage: $script_name </path/to/profile> <count, max 10>"

    exit 1

fi
	

