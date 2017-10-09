#!/usr/bin/env bash

docker build --no-cache -t igontarev/php-server .
docker push igontarev/php-server
