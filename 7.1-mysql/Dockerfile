FROM php:7.1-apache

# Install PHP extensions and PECL modules.
RUN buildDeps=" \
        default-libmysqlclient-dev \
        libbz2-dev \
        libmemcached-dev \
        libsasl2-dev \
        ghc \
        cabal-install \
    " \
    runtimeDeps=" \
        curl \
        git \
        libfreetype6-dev \
        libicu-dev \
        libjpeg-dev \
        libldap2-dev \
        libmcrypt-dev \
        libmemcachedutil2 \
        libpng-dev \
        libpq-dev \
        libxml2-dev \
        wget \
        psmisc \
        lsb-release \
        zip \
        unzip \
        libc-client-dev \
        libkrb5-dev \
        poppler-utils \
        gnupg \
        mysql-community-server \
        mysql-community-client \
    " \
    && curl -sLo /root/mysql-apt-config.deb 'https://dev.mysql.com/get/mysql-apt-config_0.8.11-1_all.deb' \
    && dpkg -i /root/mysql-apt-config.deb \
    && echo 'deb http://repo.mysql.com/apt/debian/ stretch mysql-5.7' >> /etc/apt/sources.list.d/mysql.list \
    && echo 'deb-src http://repo.mysql.com/apt/debian/ stretch mysql-5.7' >> /etc/apt/sources.list.d/mysql.list \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y $buildDeps $runtimeDeps \
    && docker-php-ext-install \
        bcmath \
        bz2 \
        calendar \
        iconv \
        intl \
        mbstring \
        mcrypt \
        mysqli \
        opcache \
        pdo_mysql \
        pdo_pgsql \
        pgsql \
        soap \
        zip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install ldap \
    && docker-php-ext-configure imap --with-imap --with-imap-ssl --with-kerberos \
    && docker-php-ext-install imap \
    && docker-php-ext-install exif \
    && pecl install memcached redis \
    && docker-php-ext-enable memcached.so redis.so \
    && echo 'sql_mode = TRADITIONAL' >> /etc/mysql/mysql.conf.d/mysqld.cnf \
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
        /var/tmp/* \
    && a2enmod rewrite

# Install Composer.
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && ln -s $(composer config --global home) /root/composer
ENV PATH=$PATH:/root/composer/vendor/bin COMPOSER_ALLOW_SUPERUSER=1

COPY "find-sh-run-shellcheck" "/usr/local/bin/find-sh-run-shellcheck"
RUN chmod 0755 /usr/local/bin/find-sh-run-shellcheck

COPY "php.ini" "/usr/local/etc/php/php.ini"
RUN cp /usr/share/zoneinfo/Europe/Rome /etc/localtime
