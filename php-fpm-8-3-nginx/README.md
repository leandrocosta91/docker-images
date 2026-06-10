# php-fpm-8-3-nginx

PHP 8.3 FPM (Alpine) + nginx + supervisor num único container. Extensões: pdo_mysql, mbstring, xml, bcmath, zip, gd, intl, exif, opcache. Timezone America/Manaus.

Contexto de build completo nesta pasta (`entrypoint/`, `nginx/`, `php/`, `supervisor/`):

```bash
docker build -f Dockerfile.prod -t leandrocosta91/php-fpm-8-3-nginx:<tag> .
```
