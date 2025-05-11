# Docker Guide

Spin up a docker container (see [docker-compose.yml](docker-compose.yml) for example) and define the environment variables (see below for options). You can remove `sftp` and `postgresql` services if you are using an external service.

# Environment Variables

By default, cronjob schedule is set to daily backups. To change the backup schedule, just add the environment variable `SCHEDULE_BACKUP` to set how often you want the backups to be done.

| Variable | Default | Info/Options |
| :- | - | - |
| SCHEDULE_BACKUP | 0 0 * * * | See [https://crontab.guru/](https://crontab.guru/) on how to configure one. |
| DB_SERVER | localhost | |
| DB_PORT | 5432 | |
| DB_NAME | postgres | Defaults to `postgres` to have access to all databases. |
| DB_USERNAME | (blank) | |
| DB_PASSWORD | (blank) | |
| BACKUP_TYPE | local | Backup options: `local`, `sftp` |
| BACKUP_RETENTION_DAYS | 7 | Retention policy on how long you want the backups to be. Supports in days for now. |
| BACKUP_SFTP_HOST | localhost | |
| BACKUP_SFTP_PORT | 22 | |
| BACKUP_SFTP_PATH | /upload | Final path where the backup files will be in. |
| BACKUP_SFTP_USERNAME | (blank) | |
| BACKUP_SFTP_PASSWORD | (blank) | |
<!-- | ALERT_TYPE | (blank) | Supported alerting options: `webhook`, `notifiers` | -->
<!-- | ALERT_DATA | (blank) | See [alert options](alerting.md) for details | -->
<!-- | DB_TO_IGNORE | (blank) | List of databases by comma to not backup | -->

# Manual Run

For testing purposes, to manually run the backup script to ensure it works for automated scheduling, just run this command:

```bash
docker compose exec app sh /app/backup.sh
```
