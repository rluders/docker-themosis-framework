#!/bin/bash

# Configure permission
find /var/www/project/htdocs/ -type d -exec chmod 750 {} +
find /var/www/project/htdocs/ -type f -exec chmod 640 {} +
find /var/www/project/htdocs/ -name wp-config.php -exec chmod 400 {} +
chmod -R 660 /var/www/project/htdocs/content/themes/$WP_THEME/app/storage/

# Configure PHP
if [ "$HOSTNAME" = "development" ]; then
    cp php/php.ini-development /usr/local/etc/php/php.ini
else
    cp php/php.ini-production /usr/local/etc/php/php.ini
fi

service apache2 restart