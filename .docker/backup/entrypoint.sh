#!/bin/bash

cron

echo "Executing initial backup..."
/usr/local/bin/backup.sh

echo "Cron service started, container is now running in foreground"
tail -f /var/log/cron.log 