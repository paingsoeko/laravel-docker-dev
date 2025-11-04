FROM php:8.4-fpm-alpine

# Metadata
LABEL app="laravel_app" \
      version="1.0" \
      maintainer="dev.kopaing@gmail.com"

# Working directory
WORKDIR /var/www/html

# Install system dependencies and PHP extensions
RUN apk add --no-cache \
    bash git curl libpng-dev libxml2-dev shadow zip unzip oniguruma-dev freetype-dev \
    libjpeg-turbo-dev libzip-dev mysql-client zlib-dev libwebp-dev icu-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip intl \
    && docker-php-ext-enable opcache \
    && rm -rf /var/cache/apk/*

# Copy Composer binary from official image
COPY --from=composer:2.8 /usr/bin/composer /usr/bin/composer

# Create non-root user (match local UID 1000 to avoid permission issues)
RUN addgroup -g 1000 www-user \
    && adduser -u 1000 -G www-user -D www-user

# Set proper permissions for Laravel writable directories
RUN mkdir -p /var/www/html/storage /var/www/html/bootstrap/cache \
    && chown -R www-user:www-user /var/www/html \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Switch to non-root user for development
USER www-user

# Expose PHP-FPM port
EXPOSE 9000

# Run PHP-FPM in foreground
CMD ["php-fpm", "-F"]
