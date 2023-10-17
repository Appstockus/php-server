#!/usr/bin/env bash

set -e

function help() {
  echo "Usage: $0 [--tag <tag>] [--push]"
  echo "  --tag <tag>  Tag to use for the image. Defaults to the current branch name with underscores replaced with dots."
  echo "  --push       Push the image to the registry."
  exit 1
}

if [ "$1" = "--help" ] || [ "$1" = "-h" ] || [ "$1" = "help" ]
  then
    help
fi

branch=$(git rev-parse --abbrev-ref HEAD)
tag=${branch//_/.}

if [ "$1" = "--tag" ]
  then
    tag="$2"
    shift 2
fi

image="ghcr.io/appstockus/php-server:$tag"

docker build -t "$image" .

echo "Built image: $image"

if [ "$1" = "--push" ]
  then
    docker push "$image"
fi
