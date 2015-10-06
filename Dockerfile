FROM eboraas/apache-php:latest
MAINTAINER Ricardo Lüders <ricardo@luders.com.br>

RUN apt-get update && apt-get -y install git curl php5-mcrypt php5-json php5-gd php-apc php-pear php5-mysql php5-curl && apt-get -y autoremove && apt-get clean

RUN /usr/sbin/a2enmod rewrite

RUN /usr/sbin/a2enmod socache_shmcb || true

ADD docker/default /etc/apache2/sites-available/
ADD docker/default-ssl /etc/apache2/sites-available/

RUN /usr/bin/curl -sS https://getcomposer.org/installer | /usr/bin/php
RUN /bin/mv composer.phar /usr/local/bin/composer

# Configure project permissions
RUN /bin/chown www-data:www-data -R /var/www/project

EXPOSE 80
EXPOSE 443

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
