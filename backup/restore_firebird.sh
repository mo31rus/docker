#!/bin/bash

echo "Restore DB to $DB_NAME \n"

SHORT_DB_NAME=${DB_NAME##*/}

BACKUP_DIR=/backup
# find latest backup in /backup directory with prefix backup_

# input db backup name
BACKUP_FN=`ls $BACKUP_DIR/*$SHORT_DB_NAME* | tail -n 1`
read -p "Enter backup name [$BACKUP_FN]: " -i "$BACKUP_FN" -e BACKUP_FN
SHORT_BACKUP_NAME=${BACKUP_FN##*/}

# show confirmation message and ask for confirmation"
read -p "Restore $BACKUP_FN into $DB_NAME?" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Restoring..."
else
    exit
fi

LOG_FN=$BACKUP_DIR/restore_${SHORT_BACKUP_NAME}_`date +'%Y%m%d_%H%M'`.log
if [[ $BACKUP_FN == *.fbk ]]; then
    /usr/local/firebird/bin/gbak -c -y $LOG_FN -v -user $DB_USER -pass $DB_PASS $BACKUP_FN $DB_NAME
else
   openssl enc -d -aes256 -in $BACKUP_FN -k $BACKUP_PASS | tar -I pbzip2 -x -C /tmp
   /usr/local/firebird/bin/gbak -c -y $LOG_FN -v -user $DB_USER -pass $DB_PASS /tmp/${SHORT_BACKUP_NAME%????????????} $DB_NAME 
fi
echo "Done."