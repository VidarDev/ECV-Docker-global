FROM debian:latest

RUN apt-get update && \
    apt-get install -y cron gzip default-mysql-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/log

COPY backup.sh /usr/local/bin/backup.sh
RUN chmod +x /usr/local/bin/backup.sh

RUN echo "0 */6 * * * root /usr/local/bin/backup.sh >> /var/log/cron.log 2>&1" > /etc/cron.d/mysql-backup

CMD ["cron", "-f"]