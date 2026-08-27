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

delete_bookmark() {
  local url="${1//\'/\'\'}" # Escape single quote before passing it to query

  sqlite3 "$PLACES_DB" "DELETE FROM moz_historyvisits WHERE place_id IN (SELECT id FROM moz_places WHERE url = '$url');"
  sqlite3 "$PLACES_DB" "DELETE FROM moz_places_metadata WHERE place_id IN (SELECT id FROM moz_places WHERE url = '$url');"
  sqlite3 "$PLACES_DB" "DELETE FROM moz_bookmarks WHERE fk IN (SELECT id FROM moz_places WHERE url = '$url');"
  sqlite3 "$PLACES_DB" "DELETE FROM moz_annos WHERE place_id IN (SELECT id FROM moz_places WHERE url = '$url');"
  sqlite3 "$PLACES_DB" "DELETE FROM moz_inputhistory WHERE place_id IN (SELECT id FROM moz_places WHERE url = '$url');"
  sqlite3 "$PLACES_DB" "DELETE FROM moz_places WHERE url = '$url';"
}

vacuum() {
  sqlite3 "$PLACES_DB" "VACUUM;"
}

TOTAL_BOOKMARKS_BEFORE_DELETION=$(sqlite3 "$PLACES_DB" "SELECT count(*) FROM moz_bookmarks")

#sqlite3 "$PLACES_DB" "SELECT places.url FROM moz_places as places JOIN moz_bookmarks as bookmarks ON places.id=bookmarks.fk ORDER BY RANDOM() LIMIT 100" | \
sqlite3 "$PLACES_DB" "SELECT places.url FROM moz_places as places JOIN moz_bookmarks as bookmarks ON places.id=bookmarks.fk ORDER BY bookmarks.dateAdded" | \
while read -r url; do
  [[ -z "$url" ]] && continue

  HTTP_STATUS=$(curl --user-agent "DeadBookmarkCleaner/1.0" --connect-timeout 5 --max-time 10 --silent --head $url | awk '/^HTTP/{code=$2} END{print code}')

  if [[ "$HTTP_STATUS" -ne 200 ]]; then      # Treat everything other than 200 as dead page.
  	echo "Deleting dead bookmark: $url [$HTTP_STATUS]"
  	delete_bookmark $url
  fi

  sleep $SLEEP_INTERVAL
done

vacuum

TOTAL_BOOKMARKS_AFTER_DELETION=$(sqlite3 "$PLACES_DB" "SELECT count(*) FROM moz_bookmarks")
TOTAL_DELETED=$((TOTAL_BOOKMARKS_BEFORE_DELETION - TOTAL_BOOKMARKS_AFTER_DELETION))
printf "\nBookmarks Deleted: $TOTAL_DELETED, Total Bookmarks before deletion: $TOTAL_BOOKMARKS_BEFORE_DELETION, Total Bookmarks after deletion: $TOTAL_BOOKMARKS_AFTER_DELETION\n"
