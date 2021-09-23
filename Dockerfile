# Base layer 0
FROM alpine:3.5
RUN apk update && apk upgrade
#RUN install php7 php7-fpm php7-opcache
#RUN apk install php7-gd php7-mysqli php7-zlib php7-curl
EXPOSE 80
ARG uid=1000
ARG user=laravel
# 1 Layer
# RUN apt-get update && apt-get install -y \
#     git \
#     curl \
#     libpng-dev \
#     libonig-dev \
#     libxml2-dev \
#     zip \
#     unzip
# 2nd Layer
#RUN apk clean && rm -rf /var/lib/apt/lists/*
# docker php modules that are required by laravelcl
#RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Create system user to run Composer and Artisan Commandsd
# 3rd Layer
#RUN adduser --disabled-password -u $uid -h/home/$user $user 3.13.3
RUN adduser -D -u $uid -h/home/$user $user
#RUN userinstall -G www-data,root -u $uid -d /home/$user $user
# 4th Layer 
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user
# Install composer
#COPY --from=composer:latest /usr/bin/composer /user/bin/composer
RUN apk add curl
#RUN apk add php5 php5-json php5-phar php5-iconv php5-openssl php5-mbstring php5-curl php5-mysqli php5-pdo_mysql php5-dom --update  --repository=http://dl-cdn.alpinelinux.org/alpine/v3.5/community --repository=http://dl-cdn.alpinelinux.org/alpine/v3.5/main
RUN apk add php5 php5-json php5-phar php5-iconv php5-openssl php5-fpm php5-curl php5-mysqli php5-pdo_mysql php5-dom php5-zip php5-ctype
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
# Set working directory
RUN composer global require laravel/installer
COPY . /var/www
WORKDIR /var/www
# RUN chmod 777 /var
# RUN chmod 777 /var/www
# RUN chmod 777 /var/www/run.sh
# Change to new system user
#USER $user
WORKDIR /var/www
RUN php composer.phar update
RUN composer install

#RUN php artisan serve --port 80 --host=0.0.0.0
#ENTRYPOINT [ "php", "artisan", "migrate" ]
#ENTRYPOINT [ "php", "artisan", "serve", "--port=80","--host=0.0.0.0" ]

ENTRYPOINT ["/bin/sh", "-c", "/var/www/run.sh"]
#ENTRYPOINT ["/bin/ash", "-c", "sleep infinity"]