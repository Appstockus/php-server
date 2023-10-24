# PHP 8.2 CLI + RoadRunner

## Tag: `8.2-rr`

Basic useful feature list:

- php-cli (8.2)
- [RoadRunner](https://roadrunner.dev/)
- [composer 2.6](https://getcomposer.org/)

## Example

`Dockerfile`

```Dockerfile
FROM ghcr.io/appstockus/php-server:8.2-rr

COPY .rr.yaml ./

COPY composer.json composer.lock ./

RUN composer install --no-dev --no-scripts --no-autoloader --no-progress --no-suggest --no-interaction

COPY src ./src

RUN composer dump-autoload --optimize --no-dev --classmap-authoritative

```
