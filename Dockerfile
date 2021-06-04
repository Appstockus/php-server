FROM alpine:3.13

RUN set -ex &&\
    apk update \
    && apk add  --no-cache \
    curl \
    bash \
    supervisor \
    nginx \
    py3-setuptools=51.3.3-r0\
    php7=7.4.19-r0 \
    php7-fpm=7.4.19-r0 \
    php7-curl=7.4.19-r0 \
    php7-zip=7.4.19-r0 \
    php7-json=7.4.19-r0 \
    php7-pgsql=7.4.19-r0 \
    php7-phar=7.4.19-r0 \
    php7-openssl=7.4.19-r0 \
    php7-mbstring=7.4.19-r0 \
    php7-gd=7.4.19-r0 \
    php7-xml=7.4.19-r0 \
    php7-simplexml=7.4.19-r0 \
    php7-dom=7.4.19-r0 \
    php7-xmlwriter=7.4.19-r0 \
    php7-tokenizer=7.4.19-r0 \
    php7-pdo_mysql=7.4.19-r0 \
    php7-session=7.4.19-r0 \
    php7-pecl-mailparse=3.1.1-r1 \
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
