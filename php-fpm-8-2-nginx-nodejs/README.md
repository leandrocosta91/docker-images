# php-fpm-8-2-nginx-nodejs

PHP 8.2 FPM (Debian) + nginx + Node.js LTS + Yarn + Composer + Chromium (Puppeteer) + Imagick. Timezone America/Manaus.

**Atenção ao contexto de build:** o `Dockerfile.prod` faz `COPY ./.docker/prod/build.prod.sh`, ou seja, ele é buildado **a partir da raiz de um projeto** que tenha essa estrutura, não desta pasta:

```bash
docker build -f <este-repo>/php-fpm-8-2-nginx-nodejs/Dockerfile.prod -t leandrocosta91/php-fpm-8-2-nginx-nodejs:<tag> <raiz-do-projeto>
```
