FROM php:8.1.32-fpm-alpine

ARG INSTALL_DIR=/srv
ARG PROJECT_NAME=satellite

WORKDIR ${INSTALL_DIR}

# download PHP deps and modules
RUN apk add --no-cache \
    curl-dev \
    freetype-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    libxml2-dev \
    libxslt-dev \
    libzip-dev \
    oniguruma-dev \
    && docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg \
    && docker-php-ext-install \
        -j$(nproc) \
        gd \
        pdo \
        pdo_mysql \
        simplexml \
        xsl \
        zip \
    && rm -rf /var/cache/apk/*

# grab composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# initialize satellite
RUN composer create-project esn/satellite-project:5.0.0 ${PROJECT_NAME} --repository-url https://packages.esn.org
