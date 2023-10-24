FROM ghcr.io/roadrunner-server/roadrunner:2023.3.0-rc.1 AS roadrunner

FROM composer:2.6 AS composer

FROM mlocati/php-extension-installer:2.1 as php-extension-installer

FROM php:8.2-cli-alpine

COPY --from=roadrunner /usr/bin/rr /usr/local/bin/rr
COPY --from=php-extension-installer /usr/bin/install-php-extensions /usr/bin/install-php-extensions

RUN install-php-extensions \
        protobuf grpc sockets \
        zip intl \
        opcache pcntl bcmath \
        pdo_mysql pdo_pgsql \
    && rm -rf /tmp/* /var/cache/apk/* \
    && echo "grpc.enable_fork_support = 1" >> /usr/local/etc/php/conf.d/docker-php-ext-grpc.ini \
    && echo "grpc.poll_strategy = epoll1" >> /usr/local/etc/php/conf.d/docker-php-ext-grpc.ini \

COPY --from=composer /usr/bin/composer /usr/bin/composer

WORKDIR /home/app

CMD ["rr", "serve", "-c", ".rr.yaml"]
