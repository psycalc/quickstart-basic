#!/bin/sh
cd /var/www
php artisan migrate
php artisan serve --host=0.0.0.0 --port=80