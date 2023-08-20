#!/bin/bash
# sudo chmod 755 prepare_server.sh

repo_url=https://github.com/havus/devops-webhook.git

git clone $repo_url repo_utils

mv repo_utils/nginx .
mv repo_utils/domain_checker.sh .
mv repo_utils/ssl_renew.sh .
mv repo_utils/docker-compose-init.yml .
mv repo_utils/docker-compose-certbot.yml .
mv repo_utils/docker-compose.yml .

rm -r repo_utils
