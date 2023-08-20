## How to setup in VM
1. Login to server with ssh
2. Setup server
```sh
$ cat /etc/apt/sources.list # Check sources.list if using idcloudhost
$ lsb_release -a # check release version
$ vim /etc/apt/sources.list # change it to default, search it from google bruh

$ sudo apt-get update
$ sudo apt-get upgrade

# if unattended-upgrades error run code below
$ ps aux | grep -i apt # get pid from and kill all pid
$ sudo kill <PID>
```

3. Install docker, [link](https://docs.docker.com/engine/install/ubuntu/)
```sh
$ for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done
$ sudo apt-get update
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
$ mkdir dhparam
$ mkdir certbot-etc
$ mkdir certbot-var
$ mkdir web-root

$ curl -O https://raw.githubusercontent.com/havus/devops-webhook/main/prepare_server.sh
$ sudo chmod 755 prepare_server.sh
$ ./prepare_server.sh

# register DNS A-Record for all subdomains
$ export DOMAIN_NAMES=wadaw.my.id,www.wadaw.my.id,jenkins.wadaw.my.id,wapi.wadaw.my.id
$ sudo chmod 755 ssl_renew.sh
$ sudo chmod 755 domain_checker.sh
$ ./domain_checker.sh $DOMAIN_NAMES

# update docker-compose.yml if necessary
$ sudo openssl dhparam -out ./dhparam/dhparam-2048.pem 2048

$ docker-compose -f docker-compose-init.yml up -d
$ docker container logs certbot

$ docker-compose -f docker-compose-certbot.yml up --force-recreate --no-deps certbot
$ docker-compose up --force-recreate -d
```

5. Renewing certificates
```sh
$ crontab -e # select using editor u prefered
0 2 * * * /home/havus/ssl_renew.sh >> /var/log/cron.log 2>&1
```


## Source
- https://mindsers.blog/post/https-using-nginx-certbot-docker/
