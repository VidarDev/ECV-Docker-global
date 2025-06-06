#!/bin/bash

if ! docker info &>/dev/null; then
  echo "Error: Docker is not running or you don't have permission"
  exit 1
fi

if ! docker compose version &>/dev/null; then
  echo "Error: Docker Compose is not available"
  exit 1
fi

echo ""
echo "Service Status:"
SERVICES=$(docker compose ps --services)
for SERVICE in $SERVICES; do
  if [ -n "$(docker compose ps --status running $SERVICE -q)" ]; then
    echo "✓ $SERVICE"
  else
    echo "✗ $SERVICE"
  fi
done

echo ""
echo "Resource Usage:"
docker stats --no-stream $(docker compose ps -q)

echo ""
echo "Volumes:"
docker volume ls --filter "name=ecv-docker-global"

echo ""
echo "Endpoints:"
endpoints=(
  "PrestaShop|http://localhost:8080"
  "phpMyAdmin|http://localhost:8081"
  "Grafana|http://localhost:3000"
  "Prometheus|http://localhost:9090"
)

for endpoint in "${endpoints[@]}"; do
  IFS="|" read -r name url <<< "$endpoint"
  if curl -s -I "$url" &>/dev/null; then
    echo "✓ $name is accessible at $url"
  else
    echo "✗ $name is not accessible at $url"
  fi
done

echo ""
echo "Backups:"
BACKUP_COUNT=$(docker exec mysql-backup bash -c "ls -1 /backup/*.sql.gz 2>/dev/null | wc -l" 2>/dev/null || echo 0)
if [ "$BACKUP_COUNT" -gt 0 ]; then
  echo "✓ $BACKUP_COUNT backup(s) found"
  docker exec mysql-backup bash -c "ls -lh /backup/*.sql.gz" 2>/dev/null
else
  echo "! No backups found. Run: docker exec mysql-backup /usr/local/bin/backup.sh"
fi