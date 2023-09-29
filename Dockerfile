FROM ghcr.io/roadrunner-server/roadrunner:2023.3.0-rc.1 AS roadrunner

FROM composer:2.6 AS composer

FROM php:8.2-cli

COPY --from=roadrunner /usr/bin/rr /usr/local/bin/rr

RUN apt-get update \
    && apt-get install -y zlib1g-dev libzip-dev libcurl4-openssl-dev libonig-dev \
    && docker-php-ext-install mbstring sockets curl zip \
    && pecl install grpc && docker-php-ext-enable grpc

COPY --from=composer /usr/bin/composer /usr/bin/composer

WORKDIR /home/app

CMD ["rr", "serve", "-c", ".rr.yaml"]
