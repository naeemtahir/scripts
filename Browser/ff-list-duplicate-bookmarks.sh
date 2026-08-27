#!/bin/bash

# Find duplicate bookmarks (same URL bookmarked more than once)
SUMMARY_QUERY="
SELECT
    p.url,
    COUNT(*) AS bookmark_count,
    GROUP_CONCAT(b.id) AS bookmark_ids,
    GROUP_CONCAT(b.title, ' | ') AS titles,
    GROUP_CONCAT(b.parent) AS parent_folder_ids
FROM moz_bookmarks b
JOIN moz_places p ON b.fk = p.id
WHERE b.type = 1
GROUP BY p.url
HAVING COUNT(*) > 1
ORDER BY bookmark_count DESC;
"

# Detailed listing of each duplicate bookmark, with its folder name
DETAILED_QUERY="
SELECT
    p.url,
    b.id AS bookmark_id,
    b.title,
    f.title AS folder_name,
    datetime(b.dateAdded / 1000000, 'unixepoch') AS date_added
FROM moz_bookmarks b
JOIN moz_places p ON b.fk = p.id
LEFT JOIN moz_bookmarks f ON b.parent = f.id
WHERE b.type = 1
  AND p.url IN (
      SELECT p2.url
      FROM moz_bookmarks b2
      JOIN moz_places p2 ON b2.fk = p2.id
      WHERE b2.type = 1
      GROUP BY p2.url
      HAVING COUNT(*) > 1
  )
ORDER BY p.url, b.dateAdded;
"

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
OUTPUT_FILE="duplicate_bookmarks_$TIMESTAMP.txt"

sqlite3 -header -column "$PLACES_DB" "$DETAILED_QUERY"  | tee $OUTPUT_FILE
#sqlite3 -header -column "$PLACES_DB" "$SUMMARY_QUERY"  | tee $OUTPUT_FILE

printf "\nDuplicate bookmarks list '$OUTPUT_FILE' ready.\n"
