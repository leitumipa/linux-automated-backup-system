#!/bin/bash

BACKUP_DIR="backup"
RESTORE_DIR="restore-test"
LOG_DIR="logs"

LOG_FILE="$LOG_DIR/restore.log"


mkdir -p "$RESTORE_DIR"
mkdir -p "$LOG_DIR"


log_message() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" >> "$LOG_FILE"
}


echo "================================"
echo " Linux Backup Restore"
echo "================================"
echo


if [ ! -d "$BACKUP_DIR" ]; then
    echo "ERROR: Backup directory tidak ditemukan."
    log_message "ERROR: Backup directory tidak ditemukan."
    exit 1
fi


echo "Available backups:"
echo

ls -1 "$BACKUP_DIR"/*.tar.gz 2>/dev/null


if [ $? -ne 0 ]; then
    echo
    echo "ERROR: Tidak ada backup yang tersedia."
    log_message "ERROR: Tidak ada backup yang tersedia."
    exit 1
fi


echo

read -p "Masukkan nama backup: " BACKUP_FILE


BACKUP_PATH="$BACKUP_DIR/$BACKUP_FILE"


if [ ! -f "$BACKUP_PATH" ]; then
    echo "ERROR: Backup file tidak ditemukan."
    log_message "ERROR: Backup file tidak ditemukan: $BACKUP_PATH"
    exit 1
fi


echo
echo "Selected backup:"
echo "$BACKUP_PATH"

echo
echo "Checking archive..."


if ! tar -tzf "$BACKUP_PATH" > /dev/null 2>&1; then
    echo "ERROR: Backup archive rusak atau tidak valid."
    log_message "ERROR: Invalid backup archive: $BACKUP_PATH"
    exit 1
fi


echo "Archive verification successful."


echo
echo "Restore destination:"
echo "$RESTORE_DIR"


mkdir -p "$RESTORE_DIR"


echo
echo "Extracting backup..."


if tar -xzf "$BACKUP_PATH" -C "$RESTORE_DIR"; then

    echo "Restore completed successfully."
    log_message "Restore completed successfully: $BACKUP_PATH"

else

    echo "ERROR: Restore failed."
    log_message "ERROR: Restore failed: $BACKUP_PATH"

    exit 1

fi


echo
echo "Restored files:"
find "$RESTORE_DIR" -type f


log_message "Restore process finished: $BACKUP_PATH"

exit 0
