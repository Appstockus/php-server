FROM ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive

ADD http://mirrors.kernel.org/ubuntu/pool/main/libp/libpng/libpng12-0_1.2.54-1ubuntu1_amd64.deb /tmp/libpng12.deb

ADD https://dl.eff.org/certbot-auto /usr/sbin/certbot-auto

ADD https://getcomposer.org/installer /composer-installer.php

RUN apt-get update \
    && apt-get install -y software-properties-common \
    && apt-add-repository ppa:ondrej/php \
    && apt-get update \
    && apt-get install -y \
        git \
        curl \
        cron \
        supervisor \
        nginx \
        nodejs \
        npm \
        # PHP
        php7.1 \
        php7.1-fpm \
        php7.1-cli \
        php7.1-curl \
        php7.1-zip \
        php7.1-json \
        php7.1-mysql \
        php7.1-pgsql \
        php7.1-mcrypt \
        php7.1-mbstring \
        php7.1-gd \
        php7.1-xml \
        php7.1-apcu \
        # Install GS to downgrade pdf files
        ghostscript \
    # libpng12
    && dpkg -i /tmp/libpng12.deb && rm /tmp/libpng12.deb \
    # Clean
    && apt-get autoremove -y \
    && apt-get clean \
    && apt-get autoclean \
    # Composer
    && php /composer-installer.php --install-dir=/usr/local/bin --filename=composer \
    && rm /composer-installer.php \
    # Node
    && npm i -g n \
    && n stable \
    && npm install -g pngquant-bin

# Nginx PHP-FPM
RUN mkdir /run/php/ \
    && echo "daemon off;" >> /etc/nginx/nginx.conf \
    && sed -i "s/display_errors = On/display_errors = Off/" /etc/php/7.1/fpm/php.ini \
    && sed -i "s/post_max_size = 8M/post_max_size = 100M/" /etc/php/7.1/fpm/php.ini \
    && sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 100M/" /etc/php/7.1/fpm/php.ini \
    && sed -i "s/user = www-data/user = root/" /etc/php/7.1/fpm/pool.d/www.conf \
    && sed -i "s/group = www-data/group = root/" /etc/php/7.1/fpm/pool.d/www.conf \
    && sed -i "s/;clear_env = no/clear_env = no/" /etc/php/7.1/fpm/pool.d/www.conf \
    && sed -i "s/memory_limit = 128M/memory_limit = 256M/" /etc/php/7.1/fpm/php.ini \
    # Supervisor conf
    && echo "[supervisord]" >> /etc/supervisor/supervisord.conf \
    && echo "nodaemon = true" >> /etc/supervisor/supervisord.conf \
    && echo "user = root" >> /etc/supervisor/supervisord.conf \
    && echo "[program:php-fpm7.1]" >> /etc/supervisor/supervisord.conf \
    && echo "command = /usr/sbin/php-fpm7.1 -FR" >> /etc/supervisor/supervisord.conf \
    && echo "autostart = true" >> /etc/supervisor/supervisord.conf \
    && echo "autorestart = true" >> /etc/supervisor/supervisord.conf \
    && echo "[program:nginx]" >> /etc/supervisor/supervisord.conf \
    && echo "command = /usr/sbin/nginx" >> /etc/supervisor/supervisord.conf \
    && echo "autostart = true" >> /etc/supervisor/supervisord.conf \
    && echo "autorestart = true" >> /etc/supervisor/supervisord.conf \
    && echo "[program:cron]" >> /etc/supervisor/supervisord.conf \
    && echo "command = cron -f" >> /etc/supervisor/supervisord.conf \
    && echo "autostart = true" >> /etc/supervisor/supervisord.conf \
    && echo "autorestart = true" >> /etc/supervisor/supervisord.conf \
    # Fix fs
    && chmod a+x /usr/sbin/certbot-auto \
    && chown -R root:root /etc/cron.d \
    && chmod -R 0644 /etc/cron.d

CMD ["/usr/bin/supervisord"]
