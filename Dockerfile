FROM alpine:3.5
RUN apk update && apk upgrade
RUN apk add curl php5 php5-json php5-phar php5-iconv php5-openssl php5-fpm php5-curl php5-mysqli php5-pdo_mysql php5-dom php5-zip php5-ctype
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer global require laravel/installer
COPY . /var/www
WORKDIR /var/www
#RUN php composer.phar update
RUN composer update --no-scripts  
RUN composer install
RUN echo $'#!/bin/sh \n\
    cd /var/www \n\
    php artisan migrate \n\
    php artisan serve --host=0.0.0.0 --port=80' >> /var/www/run.sh && \
    chmod 777 /var/www/run.sh
ENTRYPOINT ["/bin/sh", "-c", "/var/www/run.sh"]
#ENTRYPOINT ["/bin/ash", "-c", "sleep infinity"]