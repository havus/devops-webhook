## How to setup in VM
1. Login to server with ssh
2. Setup server
```sh
$ cat /etc/apt/sources.list # Check sources.list if using idcloudhost
$ lsb_release -a # check release version
$ vim /etc/apt/sources.list # change it to default, search it from google bruh

$ sudo apt-get update
$ sudo apt-get upgrade

# if sudo apt-get upgrade: unattended-upgrades error run code below
$ ps aux | grep -i apt # get pid from and kill all pid
$ sudo kill <PID>
```

3. Install docker, [link](https://docs.docker.com/engine/install/ubuntu/)
```sh
$ for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done
$ sudo apt-get install ca-certificates curl gnupg
$ sudo install -m 0755 -d /etc/apt/keyrings
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
$ sudo chmod a+r /etc/apt/keyrings/docker.gpg
$ echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

$ sudo apt-get update
$ sudo apt-get install docker-compose
$ docker --version
```

4. Prepare file config (nginx, .pem, docker-compose)
```sh
$ mkdir dhparam \
  && mkdir certbot-etc \
  && mkdir certbot-var \
  && mkdir web-root

$ curl -O https://raw.githubusercontent.com/havus/devops-webhook/main/prepare_server.sh
$ sudo chmod 755 prepare_server.sh
$ ./prepare_server.sh

# register DNS A-Record for all subdomains
$ export MAIN_DOMAIN_NAME=example.com
# $ export MAIN_DOMAIN_NAME=wadaw.my.id
$ export DOMAIN_NAMES="$MAIN_DOMAIN_NAME,www.$MAIN_DOMAIN_NAME,jenkins.$MAIN_DOMAIN_NAME,api.$MAIN_DOMAIN_NAME"
$ sudo chmod 755 ssl_renew.sh domain_checker.sh
$ ./domain_checker.sh $DOMAIN_NAMES

# update docker-compose.yml if necessary
$ sudo openssl dhparam -out ./dhparam/dhparam-2048.pem 2048

# make sure file has the correct domain:
# - nginx/conf.d/nginx.conf
# - nginx/init-conf.d/nginx.conf
# - nginx/snippets/ssl-domain.conf
$ sed -i "s/example.com/${MAIN_DOMAIN_NAME}/g" nginx/conf.d/nginx.conf nginx/init-conf.d/nginx.conf nginx/snippets/ssl-domain.conf
$ docker-compose -f docker-compose-init.yml up -d
$ docker container logs -f certbot

$ docker-compose -f docker-compose-certbot.yml up --force-recreate --no-deps certbot
$ docker-compose up --force-recreate -d
```

5. Renewing certificates
```sh
$ crontab -e # select using editor u prefered
0 1 * * * /home/havus/ssl_renew.sh >> /var/log/cron.log 2>&1
```

6. Compose down
```sh
$ docker-compose down
$ docker system prune -af
```

## Source
- https://mindsers.blog/post/https-using-nginx-certbot-docker/
