# ベースイメージ
FROM php:8.2-fpm

# 作業ディレクトリの設定
WORKDIR /var/www

# 必要なパッケージのインストール
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libzip-dev \
    libonig-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug

# Composerのインストール
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# PHP拡張モジュールのインストール
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl

# Laravelプロジェクトファイルをコンテナにコピー
COPY . /var/www

# 権限の設定
RUN chown -R www-data:www-data /var/www \
    && chmod -R 755 /var/www/storage

EXPOSE 9000

# PHP-FPMの起動
CMD ["php-fpm"]
