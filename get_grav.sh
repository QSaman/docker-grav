#!/bin/bash

GRAV_VERSION=latest

git submodule update --init --recursive

ls -a ${PWD}/grav | grep -vE '(^\.$)|(^\.\.$)|(^user$)' | xargs rm -rf

curl -o /tmp/grav-admin.zip -SL https://getgrav.org/download/core/grav-admin/${GRAV_VERSION}
unzip /tmp/grav-admin.zip -d /tmp
rm -rf /tmp/grav-admin.zip
rm -rf /tmp/grav-admin/user
rsync -a /tmp/grav-admin/ ${PWD}/grav
rm -rf /tmp/grav-admin/

docker compose build
docker compose up -d --remove-orphans
sleep 10
docker compose exec grav chown -R www-data:www-data /var/www
docker compose exec grav bin/grav install
docker compose exec grav bin/gpm install -y mathjax
docker compose exec grav bin/gpm install -y langswitcher
docker compose exec grav bin/gpm install -y language-selector
docker compose exec grav bin/gpm install -y themer
docker compose exec grav bin/gpm install -y anchors
docker compose exec grav bin/gpm install -y highlight
docker compose exec grav bin/gpm install -y devtools
docker compose exec grav bin/gpm install -y markdown-notices

docker compose down
