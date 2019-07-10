FROM php:fpm

RUN apt-get update && \
    apt-get install -y libmagickwand-dev imagemagick && \
    pecl install imagick && \
    docker-php-ext-enable imagick

COPY scripts /var/www/html
