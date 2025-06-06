FROM debian:latest

RUN apt-get update && \
    apt-get install -y cron gzip default-mysql-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/log

COPY backup.sh /usr/local/bin/backup.sh
RUN chmod +x /usr/local/bin/backup.sh

# Configurer cron pour exécuter la sauvegarde toutes les 6 heures
RUN echo "0 */6 * * * /usr/local/bin/backup.sh >> /var/log/cron.log 2>&1" > /etc/cron.d/mysql-backup && \
    chmod 0644 /etc/cron.d/mysql-backup && \
    touch /var/log/cron.log

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]