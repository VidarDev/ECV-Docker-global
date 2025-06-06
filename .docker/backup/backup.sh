#!/bin/bash

set -e
set -o pipefail

# Configuration
TIMESTAMP=$(date +'%Y%m%d_%H%M%S')
BACKUP_DIR="/backup"
MAX_BACKUPS=7
DB_HOST="mysql"
DB_USER="root"
DB_PASS=$(cat /run/secrets/mysql_root_password)
DB_NAME="prestashop"

mkdir -p "$BACKUP_DIR"

BACKUP_FILE="$BACKUP_DIR/db_backup_$TIMESTAMP.sql.gz"

echo "[$(date)] Starting backup of $DB_NAME database" 

if mysqldump -h "$DB_HOST" -u"$DB_USER" -p"$DB_PASS" "$DB_NAME" | gzip > "$BACKUP_FILE"; then
    echo "[$(date)] Backup completed successfully: $BACKUP_FILE"
else
    echo "[$(date)] Backup failed with error code $?" >&2
    exit 1
fi

echo "[$(date)] Cleaning up old backups, keeping the most recent $MAX_BACKUPS"
ls -t "$BACKUP_DIR"/db_backup_*.sql.gz | tail -n +$((MAX_BACKUPS+1)) | xargs -r rm --