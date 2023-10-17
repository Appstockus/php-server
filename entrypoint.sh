#!/usr/bin/env sh
set -e

if [ "$1" = "web" ]; then
    php-fpm
elif [ "$1" = "worker" ]; then
    rr serve -c .rr.yaml -w "$(pwd)"
else
    echo "Exec:"
    exec "$@"
fi
