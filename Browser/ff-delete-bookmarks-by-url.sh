#!/bin/bash

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 /path/to/places.sqlite /path/to/urls-to-delete.txt"
  exit 1
fi

PLACES_DB="$1"
URL_FILE="$2"

# Validate database file
if [[ ! -f "$PLACES_DB" ]]; then
  echo "Error: places.sqlite file does not exist: $PLACES_DB"
  exit 1
fi

if [[ ! -r "$PLACES_DB" ]]; then
  echo "Error: places.sqlite file is not readable: $PLACES_DB"
  exit 1
fi

# Validate URL file
if [[ ! -f "$URL_FILE" ]]; then
  echo "Error: URL file does not exist: $URL_FILE"
  exit 1
fi

if [[ ! -r "$URL_FILE" ]]; then
  echo "Error: URL file is not readable: $URL_FILE"
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
TOTAL_DELETED=0

while IFS= read -r url || [[ -n "$url" ]]; do

  # Remove leading/trailing whitespace
  url="${url#"${url%%[![:space:]]*}"}"
  url="${url%"${url##*[![:space:]]}"}"

  # Ignore blank lines
  [[ -z "$url" ]] && continue

  # Validate URL
  if [[ ! "$url" =~ ^https?://[^[:space:]]+$ ]]; then
    echo "Ignoring invalid URL: $url"
    continue
  fi


  # Check whether this URL is actually a bookmark
  BOOKMARK_COUNT=$(sqlite3 "$PLACES_DB" \
    "SELECT count(*)
     FROM moz_places AS places
     JOIN moz_bookmarks AS bookmarks ON places.id = bookmarks.fk
     WHERE places.url = '$(printf "%s" "$url" | sed "s/'/''/g")';")

  if [[ "$BOOKMARK_COUNT" -eq 0 ]]; then
    echo "Bookmark not found: $url"
    continue
  fi

  echo "Deleting bookmark: $url"
  delete_bookmark $url

  ((TOTAL_DELETED += BOOKMARK_COUNT))

done < "$URL_FILE"

vacuum

TOTAL_BOOKMARKS_AFTER_DELETION=$(sqlite3 "$PLACES_DB" "SELECT count(*) FROM moz_bookmarks")
printf "\nBookmarks Deleted: $TOTAL_DELETED, Total Bookmarks before deletion: $TOTAL_BOOKMARKS_BEFORE_DELETION, Total Bookmarks after deletion: $TOTAL_BOOKMARKS_AFTER_DELETION\n"
