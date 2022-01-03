FROM php:7.4.20-fpm-buster

ARG UID
ARG GID

RUN apt-get update && apt-get install -y \
    unzip \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libzip-dev \
    libicu-dev \
    cron --no-install-recommends && \
    docker-php-ext-configure gd && docker-php-ext-install -j$(nproc) gd && \
    docker-php-ext-install -j$(nproc) exif && \
    docker-php-ext-install -j$(nproc) bcmath && \
    docker-php-ext-configure zip && docker-php-ext-install -j$(nproc) zip && \
    docker-php-ext-install -j$(nproc) pdo_mysql && \
    docker-php-ext-configure intl && docker-php-ext-install intl && \
    apt-get clean autoclean && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/apt/lists/*

ENV PHPREDIS_VERSION 3.0.0

RUN mkdir -p /usr/src/php/ext/redis \
    && curl -L https://github.com/phpredis/phpredis/archive/$PHPREDIS_VERSION.tar.gz | tar xvz -C /usr/src/php/ext/redis --strip 1 \
    && echo 'redis' >> /usr/src/php-available-exts \
    && docker-php-ext-install redis

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN mkdir -p /usr/src/aidock/build/log && touch /usr/src/aidock/build/log/php-error.log && chmod 777 /usr/src/aidock/build/log/php-error.log

RUN mkdir -p /usr/src/aidock/build/share

RUN if grep -q "^appuser" /etc/group; then echo "Group already exists."; else groupadd -g $GID appuser; fi
RUN useradd -m -r -u $UID -g appuser appuser

# Install nvm with node and npm
RUN mkdir -p /usr/local/nvm

ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 12.16.1

RUN curl https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN npm install --global cross-env

RUN pecl install xdebug-2.9.8 \
    && docker-php-ext-enable xdebug