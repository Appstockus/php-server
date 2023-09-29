#!/usr/bin/env bash

set -e

function help() {
    echo "Usage: $0 <version> [--push]"
    echo "  version: the version of the image to build"
    echo "  --push: push the image to the registry"
}

tag=$1
if [ -z "$1" ]
  then
    echo "No version supplied, use 'latest'? [y/N]"
    read answer
    if [ "$answer" != "y" ]
      then
        help
        exit 1
    fi
    tag="latest"
fi

image="leemp/php-server:$tag"

docker build -t $image .

echo "Built image: $image"

if [ "$2" = "--push" ]
  then
    docker push $image
fi
