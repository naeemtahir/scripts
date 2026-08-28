#!/bin/bash

# Validate command-line argument
if [[ $# -ne 1 ]]; then
  echo "Usage: $0 /path/to/places.sqlite"
  exit 1
fi

PLACES_DB="$1"

# Validate database file
if [[ ! -f "$PLACES_DB" ]]; then
  echo "Error: places.sqlite file does not exist: $PLACES_DB"
  exit 1
fi

if [[ ! -r "$PLACES_DB" ]]; then
  echo "Error: places.sqlite file is not readable: $PLACES_DB"
  exit 1
fi


sqlite3 "$PLACES_DB" "SELECT count(*) FROM moz_places as places JOIN moz_bookmarks as bookmarks ON places.id=bookmarks.fk;"
