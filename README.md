# PHP 7.4.33 FPM + Nginx + gRPC

## Tag: `7.4.33-grpc`

### ❌ Deprecated soon

Image with PHP-FPM + Nginx over Supervisor will be deprecated.

Use [7.4-fpm-rr](https://github.com/AppStockus/php-server/tree/v7.4-fpm-rr) instead.

---

Basic useful feature list:

 * alpine (3.15)
 * php-fpm (7.4.33)
 * supervisor
 * [composer](https://getcomposer.org/)

## Example

`Dockerfile`

```Dockerfile
FROM ghcr.io/appstockus/php-server:7.4.33-grpc

COPY composer.json composer.lock ./

RUN composer install --no-dev --no-scripts --no-autoloader --no-progress --no-suggest --no-interaction

COPY src ./src

RUN composer dump-autoload --optimize --no-dev --classmap-authoritative

```
