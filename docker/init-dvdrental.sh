#!/bin/sh
set -e

LOCAL_ZIP="/docker/dvdrental.zip"
TMP_DIR="/tmp/dvdrental"

mkdir -p "$TMP_DIR"

# Only use local zip; error if missing
if [ ! -f "$LOCAL_ZIP" ]; then
  echo "Expected local archive at $LOCAL_ZIP but not found." >&2
  exit 1
fi

echo "Extracting dvdrental.zip..."
unzip -o "$LOCAL_ZIP" -d "$TMP_DIR" >/dev/null

if [ ! -f "$TMP_DIR/dvdrental.tar" ]; then
  echo "dvdrental.tar not found after unzip" >&2
  exit 1
fi

POSTGRES_DB="${POSTGRES_DB:-dvdrental}"
POSTGRES_USER="${POSTGRES_USER:-postgres}"
export PGPASSWORD="${POSTGRES_PASSWORD:-}"

echo "Restoring dvdrental.tar into database '$POSTGRES_DB'..."
pg_restore \
  --no-owner \
  --no-privileges \
  -U "$POSTGRES_USER" \
  -d "$POSTGRES_DB" \
  -v "$TMP_DIR/dvdrental.tar"

echo "dvdrental restore completed."