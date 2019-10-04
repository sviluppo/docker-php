FROM php:7.3-stretch

# Install PHP extensions and PECL modules.
RUN buildDeps=" \
        cabal-install \
        default-libmysqlclient-dev \
        ghc \
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
        mbstring \
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
    && curl -sLo /usr/local/bin/wait-for-it.sh https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh \
    && chmod +x /usr/local/bin/wait-for-it.sh \
    && cabal update \
    && curl -sLo /root/shellcheck-master.zip 'https://github.com/koalaman/shellcheck/archive/master.zip' \
    && cd /root \
    && unzip shellcheck-master.zip \
    && cd shellcheck-master \
    && cabal install \
    && mv /root/.cabal/bin/shellcheck /usr/local/bin \
    && apt-get purge -y --auto-remove $buildDeps \
    && rm -rf \
        /root/shellcheck-master* \
        /root/.cabal \
        /root/.ghc \
        /root/composer \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/*

# Install Composer.
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && ln -s $(composer config --global home) /root/composer \
    && composer global require hirak/prestissimo localheinz/composer-normalize
ENV PATH=$PATH:/root/composer/vendor/bin COMPOSER_ALLOW_SUPERUSER=1

COPY "find-sh-run-shellcheck" "/usr/local/bin/find-sh-run-shellcheck"
RUN chmod 0755 /usr/local/bin/find-sh-run-shellcheck

COPY "7.3.php.ini" "/usr/local/etc/php/php.ini"
RUN cp /usr/share/zoneinfo/Europe/Rome /etc/localtime

RUN curl -sSL -o /usr/local/bin/codecov https://codecov.io/bash && chmod +x /usr/local/bin/codecov
