# Imagen de PHP con todo lo necesario
FROM php:8.2-fpm

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev

# Extensiones de PHP para Laravel
RUN docker-php-ext-install pdo pdo_mysql mbstring zip exif pcntl bcmath gd

# Instalar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copiar el código del proyecto
WORKDIR /var/www/html
COPY . .

# Instalar dependencias de Laravel
RUN composer install --no-dev --optimize-autoloader

# Generar la key si no existe
RUN php artisan key:generate --force

# Exponer el puerto
EXPOSE 80

# Ejecutar Laravel
CMD ["php", "-S", "0.0.0.0:80", "-t", "public"]
