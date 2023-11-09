FROM ghcr.io/roadrunner-server/roadrunner:2023.3.0-rc.1 AS roadrunner

FROM mlocati/php-extension-installer:2.1 as php-extension-installer

FROM composer:2.6 AS composer

FROM php:7.4-fpm-alpine

COPY --from=roadrunner /usr/bin/rr /usr/local/bin/rr
COPY --from=php-extension-installer /usr/bin/install-php-extensions /usr/bin/install-php-extensions
COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN install-php-extensions \
        protobuf grpc sockets \
        zip intl \
        opcache pcntl bcmath \
        gd exif \
        pdo_mysql pdo_pgsql \
        excimer

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["web"]
