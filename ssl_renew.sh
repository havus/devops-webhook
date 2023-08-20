#!/bin/bash
# sudo chmod 755 ssl_renew.sh

COMPOSE="/usr/bin/docker-compose --ansi never"
DOCKER="/usr/bin/docker"

cd /home/havus/

$COMPOSE -f docker-compose-certbot.yml run certbot renew && $COMPOSE kill -s SIGHUP proxy_server
$DOCKER system prune -af
