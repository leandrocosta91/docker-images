#!/bin/bash

set -e

echo "🚀 Iniciando container de produção"

# Instalar cron
echo "📦 Instalando cron..."
apk add --no-cache dcron

# Configurar cron para Laravel scheduler
echo "⏰ Configurando cron para Laravel scheduler..."
echo "* * * * * cd /var/www && /usr/local/bin/php artisan schedule:run >> /var/www/storage/logs/cron.log 2>&1" | crontab -

# Criar arquivo de log do cron
touch /var/www/storage/logs/cron.log
chown www-data:www-data /var/www/storage/logs/cron.log
chmod 664 /var/www/storage/logs/cron.log

# Iniciar serviço cron
echo "🔄 Iniciando serviço cron..."
crond

echo "✅ Cron configurado e iniciado!"
echo ""


# Criar permissões em pastas
mkdir -p /var/www/public/assets/images/event/cover
mkdir -p /var/www/public/assets/images/event/gallery

chown -R www-data:www-data /var/www/storage
chown -R www-data:www-data /var/www/bootstrap/cache

chmod -R 775 /var/www/bootstrap/cache
chmod -R 775 /var/www/public/assets/images
chmod -R 775 /var/www/storage

echo "✅ Container pronto!"
echo ""

# Iniciar Supervisor (gerencia Nginx + PHP-FPM)
exec /usr/bin/supervisord -c /etc/supervisord.conf
