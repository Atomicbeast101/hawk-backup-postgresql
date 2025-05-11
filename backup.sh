#!/bin/bash

TEMP_BACKUP_DIR="/tmp"
DATE=`date +"%Y-%m-%d_%H-%M-%S"`
LOCAL_BACKUP_DIR="/backups"
BACKUP_STATUS="true"
BACKUP_FAIL_REASON=""

echo "Starting backup..."

# Backup databases
echo " - Creating database dump..."
mkdir $TEMP_BACKUP_DIR/$DATE
PGPASSWORD=$DB_PASSWORD pg_dumpall --host=$DB_SERVER --port=$DB_PORT --dbname=$DB_NAME --username=$DB_USERNAME --no-password > $TEMP_BACKUP_DIR/$DATE/dump.sql
if [ $? -ne 0 ]; then
    echo "ERROR: Unable to dump databases from $DB_SERVER:$DB_PORT!"
    BACKUP_STATUS="false"
    BACKUP_FAIL_REASON="$Unable to dump databases from $DB_SERVER:$DB_PORT"
else
    zip -r $TEMP_BACKUP_DIR/$DATE.zip $TEMP_BACKUP_DIR/$DATE/
    echo " - File $TEMP_BACKUP_DIR/$DATE.zip database dump created!"
fi
rm -rf $TEMP_BACKUP_DIR/$DATE

# Check if database dump exists
if [ "$BACKUP_STATUS" = "true" ]; then
    echo " - Validating that $TEMP_BACKUP_DIR/$DATE.zip exists..."
    if stat $TEMP_BACKUP_DIR/$DATE.zip > /dev/null 2>&1; then
        echo " - File $TEMP_BACKUP_DIR/$DATE.zip exists!"
    else
        echo "ERROR: $TEMP_BACKUP_DIR/$DATE.zip does not exist! Please check the logs for reasons why it didn't exist."
        BACKUP_STATUS="false"
        BACKUP_FAIL_REASON="$TEMP_BACKUP_DIR/$DATE.zip does not exist"
    fi
fi

# Move dumped file to final destination
if [ "$BACKUP_STATUS" = "true" ]; then
    if [ "$BACKUP_TYPE" = "local" ]; then
        mv $TEMP_BACKUP_DIR/$DATE.zip $LOCAL_BACKUP_DIR/$DATE.zip
        echo " - File $TEMP_BACKUP_DIR/$DATE.zip has been moved to $LOCAL_BACKUP_DIR/$DATE.zip!"
    elif [ "$BACKUP_TYPE" = "sftp" ]; then
        echo "put $TEMP_BACKUP_DIR/$DATE.zip" | sshpass -p $BACKUP_SFTP_PASSWORD sftp -oStrictHostKeyChecking=no -oPort=$BACKUP_SFTP_PORT "$BACKUP_SFTP_USERNAME@$BACKUP_SFTP_HOST:$BACKUP_SFTP_PATH"
        if [ $? -ne 0 ]; then
            echo "ERROR: Unable to upload $TEMP_BACKUP_DIR/$DATE.zip to SFTP endpoint ($BACKUP_SFTP_HOST:$BACKUP_SFTP_PATH/$DATE.zip)!"
            BACKUP_STATUS="false"
            BACKUP_FAIL_REASON="$TEMP_BACKUP_DIR/$DATE.zip does not exist"
        else
            echo " - File $TEMP_BACKUP_DIR/$DATE.zip has been uploaded to SFTP endpoint ($BACKUP_SFTP_HOST:$BACKUP_SFTP_PATH/$DATE.zip)!"
        fi
        rm $TEMP_BACKUP_DIR/$DATE.zip
    else
        echo "ERROR: $BACKUP_TYPE is not supported! Supported options: local, sftp"
        BACKUP_STATUS="false"
        BACKUP_FAIL_REASON="$BACKUP_TYPE is not supported"
    fi
fi

# Alert user of backup failure
if [ "$BACKUP_STATUS" = "false" ]; then
    echo "TODO: Add alert code here..."
fi

echo "Backup completed!"
