#!/bin/bash

BACKUP_FN=${DB_NAME##*/}_`date +'%Y%m%d_%H%M'`.fbk
BACKUP_DIR=/backup

echo "Backup DB $DB_NAME to $BACKUP_DIR/$BACKUP_FN"

LOG_FN=$BACKUP_DIR/backup.log
rm -f $LOG_FN
/usr/local/firebird/bin/gbak -b -g -y $LOG_FN -v -user $DB_USER -pass $DB_PASS $DB_NAME /tmp/$BACKUP_FN
tar -I pbzip2 -c --remove-files --directory=/tmp $BACKUP_FN | openssl enc -e -aes256 -out $BACKUP_DIR/$BACKUP_FN.tar.bz2.enc -k $BACKUP_PASS
