FROM alpine:edge

RUN apk update \
    && apk update \
    && apk add  \
    git \
    curl \
    wget \
    bash \
    lcms2-dev \
    zsh \
    nano \
    dpkg \
    supervisor \
    nginx \
    libpng-dev \
    php7=7.4.14-r0 \
    php7-fpm=7.4.14-r0 \
    php7-curl=7.4.14-r0 \
    php7-zip=7.4.14-r0 \
    php7-json=7.4.14-r0 \
    php7-pgsql=7.4.14-r0 \
    php7-phar=7.4.14-r0 \
    php7-openssl=7.4.14-r0 \
    php7-mbstring=7.4.14-r0 \
    php7-gd=7.4.14-r0 \
    php7-xml=7.4.14-r0 \
    php7-simplexml=7.4.14-r0 \
    php7-dom=7.4.14-r0 \
    php7-xmlwriter=7.4.14-r0 \
    php7-tokenizer=7.4.14-r0 \
    php7-pdo_mysql=7.4.14-r0 \
    php7-session=7.4.14-r0 \
    php7-pecl-mailparse



RUN apk del

RUN mkdir -p /run/nginx


RUN mkdir /run/php \
    && echo "daemon off;" >> /etc/nginx/nginx.conf \
    && sed -i "s/display_errors = On/display_errors = Off/" /etc/php7/php.ini \
    && sed -i "s/post_max_size = 8M/post_max_size = 100M/" /etc/php7/php.ini \
    && sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 100M/" /etc/php7/php.ini \
    && sed -i "s/user = www-data/user = root/" /etc/php7/php-fpm.d/www.conf \
    && sed -i "s/group = www-data/group = root/" /etc/php7/php-fpm.d/www.conf

# Supervisor conf
RUN echo "[supervisord]" >> /etc/supervisord.conf \
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



# Install Zsh
RUN git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc \
    && sed -i "s/robbyrussell/af-magic/" ~/.zshrc \
    && echo TERM=xterm >> /root/.zshrc

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer 

COPY ./conf /etc/nginx/conf.d
COPY ./www /var/www
COPY ./supervisor /etc/supervisor/conf.d

RUN cd /var/www && composer install

# Add certbot
# https://certbot.eff.org/
RUN wget -P /usr/sbin/ https://dl.eff.org/certbot-auto \
    && chmod a+x /usr/sbin/certbot-auto

RUN chown -R root:root /etc/crontabs && chmod -R 0644 /etc/crontabs
# RUN chown -R www-data:www-data /var/www

CMD ["/usr/bin/supervisord"]


# Install GS to downgrade pdf files
RUN apk update && apk add ghostscript 
RUN apk update && apk add nodejs 
RUN apk update 
RUN apk add npm 
RUN npm i -g n 
RUN n stable
