# Docker - alpine + nginx + php

Basic useful feature list:

 * alpine (3.15)
 * php-fpm (7.4.30)
 * supervisor
 * [composer](https://getcomposer.org/)

## Example

*docker-compose.yml*:

```yaml
ges:
  platform: linux/amd64
  image: leemp/php-server:${TAG_VERSION}
  healthcheck:
    test: "true"
  build:
    context: ./apps/ges
    args:
      VERSION: ${TAG_VERSION}
      COMPOSER_INSTALL_DEV: 'true'
  ports:
    - "80:5000"
  env_file: ./.env
  environment:
    TZ: ${TZ:-Europe/London}
    APP_DEBUG: 'true'
    ENV_OVERLOAD: 'true'
  command: bash -c '(apk add tzdata && cp /usr/share/zoneinfo/$TZ /etc/localtime && date) 
    && ([[ -z "$SKIP_INIT" ]] && (
      cd /var/www 
      && composer install --no-progress -v
      && npm install 
    ) || true)
      && cd / && /usr/bin/supervisord'
  volumes:
    - ./apps/ges/www:/var/www/
    - ./apps/ges/nginx-config:/etc/nginx/conf.d:ro
    - ./apps/ges/logs/nginx:/var/log/nginx
    - ./apps/ges/supervisor:/etc/supervisor.d:ro
    - ./apps/ges/filebeat/filebeat.yml:/etc/filebeat.yml
    - ./apps/ges/xdebug:/xdebug
```
