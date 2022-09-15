FROM alpine:3.15

RUN set -ex &&\
    apk update \
    && apk add  --no-cache \
    curl \
    bash \
    supervisor \
    nginx \
    py3-setuptools=52.0.0-r4 \
    php7=7.4.30-r0 \
    php7-fpm=7.4.30-r0 \
    php7-curl \
    php7-zip \
    php7-json \
    php7-pgsql \
    php7-phar \
    php7-openssl \
    php7-mbstring \
    php7-gd \
    php7-xml \
    php7-simplexml \
    php7-dom \
    php7-xmlwriter \
    php7-tokenizer \
    php7-pdo_mysql \
    php7-session \
    php7-pecl-mailparse \
    php7-pecl-apcu \
    php7-pecl-mcrypt \
    php-fileinfo \
    php-sodium \
    php-sockets \
    php7-iconv \
    php7-mysqli \
    && apk del \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

RUN mkdir -p /run/nginx \
    && chown -R root:root /etc/crontabs && chmod -R 0644 /etc/crontabs \
    && mkdir /run/php \
    && echo "daemon off;" >> /etc/nginx/nginx.conf \
    && sed -i "s/display_errors = On/display_errors = Off/" /etc/php7/php.ini \
    && sed -i "s/post_max_size = 8M/post_max_size = 100M/" /etc/php7/php.ini \
    && sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 100M/" /etc/php7/php.ini \
    && sed -i "s/user = www-data/user = root/" /etc/php7/php-fpm.d/www.conf \
    && sed -i "s/group = www-data/group = root/" /etc/php7/php-fpm.d/www.conf \
# Supervisor conf
    && echo "[supervisord]" >> /etc/supervisord.conf \
    && echo "nodaemon = true" >> /etc/supervisord.conf \
    && echo "user = root" >> /etc/supervisord.conf \
    && echo "[program:php-fpm7]" >> /etc/supervisord.conf \
    && echo "command = /usr/sbin/php-fpm7 -FR" >> /etc/supervisord.conf \
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
