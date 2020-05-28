#!/bin/bash

if [ "$#" -eq 3 ]  && [ -d "$1" ] && ([[ "$2" == "-l" ]] || [[ "$2" == "-d" ]]); then
    PROFILE_DIR="$1"

    if [ "$2" == "-d" ]; then
        sqlite3 "$PROFILE_DIR"/places.sqlite "DELETE FROM moz_bookmarks WHERE id IN (SELECT bookmarks.id FROM moz_places as places JOIN moz_bookmarks as bookmarks ON places.id=bookmarks.fk where places.URL like '$3');"
        echo "All bookmkarks matching $3 deleted"
    else
        sqlite3 "$PROFILE_DIR"/places.sqlite "SELECT places.id, places.URL, places.GUID, bookmarks.title, bookmarks.id, bookmarks.parent FROM moz_places as places JOIN moz_bookmarks as bookmarks ON places.id=bookmarks.fk where places.URL like '$3'"
    fi
else
    script_name=`basename "$0"`
    echo "Usage: $script_name </path/to/profile> <-l|-d> <SQL 'like' clause>"
    echo "  -l, List bookmarks matching SQL clause"
    echo "  -d, Delete bookmarks matching SQL clause"

    exit 1
fi
