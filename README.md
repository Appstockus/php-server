# nginx + php5.6-fpm

Basic useful feature list:

 * supervisor
 * cron
 * [composer](https://getcomposer.org/)
 * [certbot-auto](https://certbot.eff.org/)
 * [zsh](https://github.com/robbyrussell/oh-my-zsh)


## Example

*docker-compose.yml*:

```yaml
php-server:
  image: leemp/php-server
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
