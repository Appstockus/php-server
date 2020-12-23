FROM ubuntu:18.04

RUN apt-get update \
    && apt-get install software-properties-common -y \
    && LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php \
    && apt-get update \
    && apt-get install -y \
    git \
    curl \
    cron \
    wget \
    zsh \
    nano \
    supervisor \
    nginx \

    php7.4 \
    php7.4-fpm \
    php7.4-cli \
    php7.4-curl \
    php7.4-zip \
    php7.4-json \
    php7.4-mysql \
    php7.4-pgsql \
    # php7.4-mcrypt \
    php7.4-mbstring \
    php7.4-gd \
    php7.4-xml


RUN apt-get autoremove -y && \
    apt-get clean && \
    apt-get autoclean


RUN mkdir /run/php \
    && echo "daemon off;" >> /etc/nginx/nginx.conf \
    && sed -i "s/display_errors = On/display_errors = Off/" /etc/php/7.4/fpm/php.ini \
    && sed -i "s/post_max_size = 8M/post_max_size = 100M/" /etc/php/7.4/fpm/php.ini \
    && sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 100M/" /etc/php/7.4/fpm/php.ini \
    && sed -i "s/user = www-data/user = root/" /etc/php/7.4/fpm/pool.d/www.conf \
    && sed -i "s/group = www-data/group = root/" /etc/php/7.4/fpm/pool.d/www.conf

# Supervisor conf
RUN echo "[supervisord]" >> /etc/supervisor/supervisord.conf \
    && echo "nodaemon = true" >> /etc/supervisor/supervisord.conf \
    && echo "user = root" >> /etc/supervisor/supervisord.conf \
    && echo "[program:php-fpm7.4]" >> /etc/supervisor/supervisord.conf \
    && echo "command = /usr/sbin/php-fpm7.4 -FR" >> /etc/supervisor/supervisord.conf \
    && echo "autostart = true" >> /etc/supervisor/supervisord.conf \
    && echo "autorestart = true" >> /etc/supervisor/supervisord.conf \
    && echo "[program:nginx]" >> /etc/supervisor/supervisord.conf \
    && echo "command = /usr/sbin/nginx" >> /etc/supervisor/supervisord.conf \
    && echo "autostart = true" >> /etc/supervisor/supervisord.conf \
    && echo "autorestart = true" >> /etc/supervisor/supervisord.conf \
    && echo "[program:cron]" >> /etc/supervisor/supervisord.conf \
    && echo "command = cron -f" >> /etc/supervisor/supervisord.conf \
    && echo "autostart = true" >> /etc/supervisor/supervisord.conf \
    && echo "autorestart = true" >> /etc/supervisor/supervisord.conf



# Install Zsh
RUN git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc \
    && sed -i "s/robbyrussell/af-magic/" ~/.zshrc \
    && echo TERM=xterm >> /root/.zshrc

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Add certbot
# https://certbot.eff.org/
RUN wget -P /usr/sbin/ https://dl.eff.org/certbot-auto \
    && chmod a+x /usr/sbin/certbot-auto

RUN chown -R root:root /etc/cron.d && chmod -R 0644 /etc/cron.d

CMD ["/usr/bin/supervisord"]

RUN wget -q -O /tmp/libpng12.deb http://mirrors.kernel.org/ubuntu/pool/main/libp/libpng/libpng12-0_1.2.54-1ubuntu1_amd64.deb && dpkg -i /tmp/libpng12.deb && rm /tmp/libpng12.deb

RUN wget -q -O /tmp/libpng12.deb http://mirrors.kernel.org/ubuntu/pool/main/libp/libpng/libpng12-0_1.2.54-1ubuntu1_amd64.deb  && dpkg -i /tmp/libpng12.deb && rm /tmp/libpng12.deb

# Install GS to downgrade pdf files
RUN apt-get update && apt-get -y install ghostscript && apt-get clean
RUN apt-get update && apt-get install nodejs -y && apt-get update -y && apt-get install npm -y && npm i -g n && n stable && npm i -g pm2 && npm install -g pngquant-bin
