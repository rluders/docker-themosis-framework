FROM eboraas/apache-php
MAINTAINER Ricardo Lüders <ricardo@luders.com.br>

RUN echo "+ Installing dependencies..."
RUN apt-get update && apt-get -y install git curl php5-mcrypt php5-json php5-gd php-apc php-pear php5-mysql php5-curl && apt-get -y autoremove && apt-get clean

RUN echo "+ Configure Apache modules..."
RUN /usr/sbin/a2enmod rewrite
RUN /usr/sbin/a2enmod socache_shmcb || true

RUN echo "+ Configure Virtual Hosts..."
RUN rm -Rf /etc/apache2/sites-available/*.conf
COPY apache/default.conf /etc/apache2/sites-available
COPY apache/default-ssl.conf /etc/apache2/sites-available

RUN a2ensite default
RUN a2ensite default-ssl

RUN echo "+ Installing composer..."
RUN /usr/bin/curl -sS https://getcomposer.org/installer | /usr/bin/php
RUN /bin/mv composer.phar /usr/local/bin/composer

RUN echo "+ Prepare project folder..."
RUN mkdir -p /var/www/project
RUN /bin/chown www-data:www-data -R /var/www/project

ADD . /var/www/project

EXPOSE 80
EXPOSE 443

RUN echo ">>> Ready to go!"

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
