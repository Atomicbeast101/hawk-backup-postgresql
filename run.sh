#!/bin/bash

# Schedule Backup Job
echo "$SCHEDULE_BACKUP root /app/backup.sh" > /app/backup.cron
chmod 0644 /app/backup.cron
crontab /app/backup.cron

# Start Cron in Background
crond -f
