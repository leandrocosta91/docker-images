FROM wordpress:6.3.0-apache

RUN apt-get update && docker-php-ext-install pdo_mysql

# Reconstruído via docker history: a imagem em produção tem uma camada final
# que sobrescreve /usr/local/etc/php (php.ini + conf.d customizados).
# O conteúdo em config/php foi extraído da própria imagem em 2026-06-10.
COPY config/php /usr/local/etc/php
