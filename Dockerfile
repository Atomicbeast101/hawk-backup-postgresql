ARG OS_VERSION=latest
FROM alpine:${OS_VERSION}

ARG ARCH=amd64
ENV SCHEDULE_BACKUP="0 0 * * *"
ENV DB_SERVER=localhost
ENV DB_PORT=5432
ENV DB_USERNAME=
ENV DB_PASSWORD=
ENV DB_TO_IGNORE=
ENV BACKUP_TYPE=local
ENV BACKUP_RETENTION_DAYS=7
ENV BACKUP_SFTP_HOST=localhost
ENV BACKUP_SFTP_PORT=22
ENV BACKUP_SFTP_PATH=/upload
ENV BACKUP_SFTP_USERNAME=
ENV BACKUP_SFTP_PASSWORD=

# Setup
RUN mkdir /app
RUN mkdir /backups
COPY os_packages.txt /
RUN xargs -a os_packages.txt apk add --no-cache
# COPY pip_packages.txt /
# RUN pip install --no-cache-dir --break-system-packages -r /pip_packages.txt
RUN rm /os_packages.txt

# Transfer Files Over
COPY backup.sh /app
COPY run.sh /app
RUN chmod +x /app/backup.sh /app/run.sh

# Start App
WORKDIR /app
CMD ["/bin/sh", "/app/run.sh"]
