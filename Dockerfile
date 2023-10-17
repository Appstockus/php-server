FROM mlocati/php-extension-installer:2.1 as php-ext-installer

FROM php:7.4.33-fpm-alpine3.16

COPY --from=php-ext-installer /usr/bin/install-php-extensions /usr/bin/install-php-extensions

RUN set -ex \
    && apk update \
    && apk add  --no-cache \
    curl \
    bash \
    supervisor \
    nginx \
    py3-setuptools \
    && apk del \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

RUN install-php-extensions  \
    zip gd dom sockets \
    pdo_mysql mysqli \
    mailparse apcu mcrypt \
    protobuf grpc

SHELL ["/bin/bash", "-c"]

RUN mkdir -p /run/{nginx,php} \
    && chown -R root:root /etc/crontabs && chmod -R 0644 /etc/crontabs \
    && echo "daemon off;" >> /etc/nginx/nginx.conf \
    && sed -i "s/post_max_size = 8M/post_max_size = 100M/" /usr/local/etc/php/php.ini-{development,production} \
    && sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 100M/" /usr/local/etc/php/php.ini-{development,production} \
    && sed -i "s/memory_limit = 128M/memory_limit = 256M/" /usr/local/etc/php/php.ini-{development,production} \
    && sed -i "s/user = www-data/user = root/" /usr/local/etc/php-fpm.d/www.conf \
    && sed -i "s/group = www-data/group = root/" /usr/local/etc/php-fpm.d/www.conf \
# Supervisor conf
    && echo "[supervisord]" >> /etc/supervisord.conf \
    && echo "nodaemon = true" >> /etc/supervisord.conf \
    && echo "user = root" >> /etc/supervisord.conf \
    && echo "[program:php-fpm]" >> /etc/supervisord.conf \
    && echo "command = /usr/local/sbin/php-fpm -FR" >> /etc/supervisord.conf \
    && echo "autostart = true" >> /etc/supervisord.conf \
    && echo "autorestart = true" >> /etc/supervisord.conf \
    && echo "[program:nginx]" >> /etc/supervisord.conf \
    && echo "command = /usr/sbin/nginx" >> /etc/supervisord.conf \
    && echo "autostart = true" >> /etc/supervisord.conf \
    && echo "autorestart = true" >> /etc/supervisord.conf \
    && echo "[program:crond]" >> /etc/supervisord.conf \
    && echo "command = crond -f" >> /etc/supervisord.conf \
    && echo "autostart = true" >> /etc/supervisord.conf \
    && echo "autorestart = true" >> /etc/supervisord.conf

CMD /usr/bin/supervisord
