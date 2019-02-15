FROM php:7.1

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
        lsb-release \
        poppler-utils \
        psmisc \
        unzip \
        wget \
        zip \
    " \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y $buildDeps $runtimeDeps \
    && curl -sLo /root/mysql-apt-config.deb 'https://dev.mysql.com/get/mysql-apt-config_0.8.12-1_all.deb' \
    && dpkg -i /root/mysql-apt-config.deb \
    && echo 'deb http://repo.mysql.com/apt/debian/ stretch mysql-5.7' >> /etc/apt/sources.list.d/mysql.list \
    && echo 'deb-src http://repo.mysql.com/apt/debian/ stretch mysql-5.7' >> /etc/apt/sources.list.d/mysql.list \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-community-server mysql-community-client \
    && apt-get clean \
    && echo 'sql_mode = TRADITIONAL' >> /etc/mysql/mysql.conf.d/mysqld.cnf \
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
        /root/mysql-apt-config.deb \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/*

# Install Composer.
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && ln -s $(composer config --global home) /root/composer
ENV PATH=$PATH:/root/composer/vendor/bin COMPOSER_ALLOW_SUPERUSER=1

COPY "find-sh-run-shellcheck" "/usr/local/bin/find-sh-run-shellcheck"
RUN chmod 0755 /usr/local/bin/find-sh-run-shellcheck

COPY "php.ini" "/usr/local/etc/php/php.ini"
RUN cp /usr/share/zoneinfo/Europe/Rome /etc/localtime
