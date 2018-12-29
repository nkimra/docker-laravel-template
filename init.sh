#!/bin/bash

# Laravel Project Name
export LARAVEL_PROJECT_NAME=sample

# nginx setting for docker-compose.yml
export CONTAINER_NAME_NGINX=laravel_nginx

# php setting for docker-compose.yml
export CONTAINER_NAME_PHP=laravel_php

# mariadb setting for docker-compose.yml
export CONTAINER_NAME_DB=laravel_db
export ROOT_PASSWORD=password
export DB_NAME=db_laravel

# replace default.conf
cat web/default.txt | sed -e "s/laravel/${LARAVEL_PROJECT_NAME}/g" > web/default.conf

# run docker-compose
docker-compose up -d

# create laravel project
docker-compose exec php composer create-project --prefer-dist laravel/laravel ${LARAVEL_PROJECT_NAME} "5.7.*"

# create env
cd src/${LARAVEL_PROJECT_NAME}
cat .env.example | sed -e "s/DB_HOST=127.0.0.1/DB_HOST=${CONTAINER_NAME_DB}/g"\
 -e "s/DB_DATABASE=homestead/DB_DATABASE=${DB_NAME}/g"\
 -e "s/DB_USERNAME=homestead/DB_USERNAME=root/g"\
 -e "s/DB_PASSWORD=secret/DB_PASSWORD=${ROOT_PASSWORD}/g" > .env

# generate laravel key
docker-compose exec php php ${LARAVEL_PROJECT_NAME}/artisan key:generate
