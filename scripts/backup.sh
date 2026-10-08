#!/bin/bash

SOURCE_DIR="data"
BACKUP_DIR="backup"
LOG_DIR="logs"

RETENTION_COUNT=5

TIMESTAMP=$(date +"%Y-%m-%d_%H%M%S")

BACKUP_FILE="backup-${TIMESTAMP}.tar.gz"
BACKUP_PATH="$BACKUP_DIR/$BACKUP_FILE"

LOG_FILE="$LOG_DIR/backup.log"


log_message() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" >> "$LOG_FILE"
}


mkdir -p "$BACKUP_DIR"
mkdir -p "$LOG_DIR"


log_message "Backup started"


if [ ! -d "$SOURCE_DIR" ]; then
    echo "ERROR: Source directory '$SOURCE_DIR' tidak ditemukan."
    log_message "ERROR: Source directory '$SOURCE_DIR' tidak ditemukan."
    exit 1
fi


echo "================================"
echo " Linux Automated Backup"
echo "================================"
echo

echo "Source directory : $SOURCE_DIR"
echo "Backup directory : $BACKUP_DIR"
echo "Backup file      : $BACKUP_PATH"
echo


log_message "Creating backup: $BACKUP_PATH"


if tar -czf "$BACKUP_PATH" "$SOURCE_DIR"; then

    echo "Backup archive created."
    log_message "Backup archive created: $BACKUP_PATH"

else

    echo "ERROR: Backup creation failed."
    log_message "ERROR: Backup creation failed."

    exit 1

fi


echo "Verifying backup..."


if tar -tzf "$BACKUP_PATH" > /dev/null; then

    echo "Backup verification successful."
    log_message "Backup verification successful: $BACKUP_PATH"

else

    echo "ERROR: Backup verification failed."
    log_message "ERROR: Backup verification failed: $BACKUP_PATH"

    exit 1

fi


echo
echo "Applying retention policy..."


BACKUPS=()

while IFS= read -r BACKUP; do
    BACKUPS+=("$BACKUP")
done < <(find "$BACKUP_DIR" -maxdepth 1 -type f -name "*.tar.gz" -printf "%T@ %p\n" | sort -nr | cut -d' ' -f2-)


BACKUP_COUNT=${#BACKUPS[@]}


echo "Total backups: $BACKUP_COUNT"
log_message "Total backups: $BACKUP_COUNT"


if [ "$BACKUP_COUNT" -gt "$RETENTION_COUNT" ]; then

    for ((i=RETENTION_COUNT; i<BACKUP_COUNT; i++)); do

        OLD_BACKUP="${BACKUPS[$i]}"

        echo "Removing old backup: $OLD_BACKUP"
        log_message "Removing old backup: $OLD_BACKUP"

        rm -- "$OLD_BACKUP"

    done

else

    echo "No old backups need to be removed."
    log_message "No old backups need to be removed."

fi


echo
echo "Backup completed successfully."

log_message "Backup completed successfully: $BACKUP_PATH"

exit 0
