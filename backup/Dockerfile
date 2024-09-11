FROM jacobalberty/firebird:2.5.9-sc

# Install necessary packages
RUN apt-get update && apt-get install -y cron pbzip2 openssl

# create backup folder
RUN mkdir -p /backup

# Copy the backup script into the container
COPY backup_firebird.sh /usr/local/bin/backup_firebird.sh
COPY upload_to_S3.sh /usr/local/bin/upload_to_S3.sh
COPY restore_firebird.sh /usr/local/bin/restore_firebird.sh

# Give execution rights to the backup script
RUN chmod +x /usr/local/bin/backup_firebird.sh
RUN chmod +x /usr/local/bin/upload_to_S3.sh
RUN chmod +x /usr/local/bin/restore_firebird.sh

# Add the cron job
RUN (crontab -l ; echo "28 2 * * * /usr/local/bin/backup_firebird.sh") | crontab

ENV TZ=Europe/Moscow

# Run the command on container startup
CMD ["cron", "-f"]