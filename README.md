# nginx + php7.4-fpm

### Basic useful feature list:

 * supervisor
 * cron
 * [composer](https://getcomposer.org/)
 * [certbot-auto](https://certbot.eff.org/)
 * [zsh](https://github.com/robbyrussell/oh-my-zsh)

### How to run example

```bash
git clone git@github.com:AppStockus/php-server.git
cd php-server
docker-compose up -d
```

Open [https://localhost](https://localhost) in your browser

![phpinfo](http://storage7.static.itmages.com/i/17/1009/h_1507569720_7349817_3890ca183b.png)

#### Example *docker-compose.yml*

```yaml
php-server:
  image: leemp/php-server:latest
  ports:
    - "80:80"
    - "443:443"
  volumes:
    - ./www:/var/www
    - ./sites:/etc/nginx/sites-enabled
    - ./logs/nginx:/var/log/nginx
    - ./logs/php:/var/log/php
    - ./cron:/etc/cron.d
    - ./supervisor:/etc/supervisor/conf.d
    - ./letsencrypt:/etc/letsencrypt
    - ./lib/letsencrypt:/var/lib/letsencrypt
```
