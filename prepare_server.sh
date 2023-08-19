# sudo chmod 755 prepare_server.sh

repo_url=https://github.com/havus/devops-webhook.git

git clone $repo_url repo_utils
mv repo_utils/nginx .
mv repo_utils/docker-compose.yml .

rm -r repo_utils
