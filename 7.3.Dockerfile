FROM php:7.3

# Install PHP extensions and PECL modules.
RUN buildDeps=" \
        default-libmysqlclient-dev \
        libbz2-dev \
        libsasl2-dev \
    " \
    runtimeDeps=" \
        curl \
        git \
        gnupg \
        libc-client-dev \
        libfreetype6-dev \
        libicu-dev \
        libjpeg-dev \
        libkrb5-dev \
        libpng-dev \
        libpq-dev \
        libxml2-dev \
        libzip-dev \
        lsb-release \
        poppler-utils \
        psmisc \
        unzip \
        wget \
        zip \
    " \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y $buildDeps $runtimeDeps \
    && apt-get clean \
    && docker-php-ext-install \
        bcmath \
        bz2 \
        calendar \
        iconv \
        intl \
        mysqli \
        opcache \
        pdo_mysql \
        pdo_pgsql \
        pgsql \
        soap \
        zip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-configure imap --with-imap --with-imap-ssl --with-kerberos \
    && docker-php-ext-install imap \
    && docker-php-ext-install exif \
    && pecl install pcov \
    && docker-php-ext-enable pcov \
    && wget -O /usr/local/bin/phive https://phar.io/releases/phive.phar \
    && chmod +x /usr/local/bin/phive \
    && phive install --global --trust-gpg-keys C00543248C87FB13,D2CCAC42F6295E7D,8AC095C96F5C623D composer-normalize composer-require-checker composer-unused \
    && wget -O /usr/local/bin/robo http://robo.li/robo.phar \
    && chmod +x /usr/local/bin/robo \
    && curl -sLo /usr/local/bin/wait-for-it.sh https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh \
    && chmod +x /usr/local/bin/wait-for-it.sh \
    && apt-get purge -y --auto-remove $buildDeps \
    && rm -rf \
        /root/composer \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/*

# Install Composer.
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && ln -s $(composer config --global home) /root/composer \
    && composer global require hirak/prestissimo
ENV COMPOSER_ALLOW_SUPERUSER=1

COPY "7.3.php.ini" "/usr/local/etc/php/php.ini"
RUN cp /usr/share/zoneinfo/Europe/Rome /etc/localtime

RUN curl -sSL -o /usr/local/bin/codecov https://codecov.io/bash && chmod +x /usr/local/bin/codecov
