# PHP 7.4 FPM + RoadRunner

## Tag: `7.4-fpm-rr`

Basic useful feature list:

- php-fpm (7.4)
- [RoadRunner](https://roadrunner.dev/)
- [composer 2.6](https://getcomposer.org/)

## Example

`Dockerfile`

```Dockerfile
FROM ghcr.io/appstockus/php-server:7.4-fpm-rr

COPY .rr.yaml ./

COPY composer.json composer.lock ./

RUN composer install --no-dev --no-scripts --no-autoloader --no-progress --no-suggest --no-interaction

COPY src ./src

RUN composer dump-autoload --optimize --no-dev --classmap-authoritative

```
