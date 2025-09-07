#!/bin/sh
set -e

ZIP_URL="https://www.postgresqltutorial.com/wp-content/uploads/2019/05/dvdrental.zip"
TMP_DIR="/tmp/dvdrental"

mkdir -p "$TMP_DIR"
echo "Downloading dvdrental dataset (primary URL)..."
curl -fsSL -o "$TMP_DIR/dvdrental.zip" "$ZIP_URL" || true

echo "Unzipping dvdrental.zip..."
unzip -o "$TMP_DIR/dvdrental.zip" -d "$TMP_DIR" >/dev/null

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


