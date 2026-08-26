#!/bin/bash

SLEEP_INTERVAL=1

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

TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
OUTPUT_FILE="dead_bookmarks_$TIMESTAMP.txt"
touch $OUTPUT_FILE

sqlite3 "$PLACES_DB" "SELECT places.url FROM moz_places as places JOIN moz_bookmarks as bookmarks ON places.id=bookmarks.fk ORDER BY bookmarks.dateAdded" | \
while read -r url; do
  [[ -z "$url" ]] && continue

  HTTP_STATUS=$(curl --user-agent "BookmarkManager/1.0" --connect-timeout 5 --max-time 10 --silent --head $url | awk '/^HTTP/{code=$2} END{print code}')

  if [[ "$HTTP_STATUS" -ne 200 ]]; then   # Treat everything (including empty status) but 200 as dead page.
  	echo "$url" | tee -a $OUTPUT_FILE
  fi

  sleep $SLEEP_INTERVAL
done

echo "\nDead bookmarks list '$OUTPUT_FILE' ready."
