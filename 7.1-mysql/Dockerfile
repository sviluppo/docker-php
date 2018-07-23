FROM chialab/php:7.1

RUN \
    apt-get update \
    && apt-get install -y wget psmisc lsb-release zip unzip libc-client-dev libkrb5-dev poppler-utils gnupg ghc cabal-install \
    && docker-php-ext-configure imap --with-imap --with-imap-ssl --with-kerberos \
    && docker-php-ext-install imap \
    && curl -sLo /root/mysql-apt-config.deb 'https://dev.mysql.com/get/mysql-apt-config_0.8.10-1_all.deb' \
    && dpkg -i /root/mysql-apt-config.deb \
    && echo 'deb http://repo.mysql.com/apt/debian/ stretch mysql-5.7' >> /etc/apt/sources.list.d/mysql.list \
    && echo 'deb-src http://repo.mysql.com/apt/debian/ stretch mysql-5.7' >> /etc/apt/sources.list.d/mysql.list \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-community-server mysql-community-client \
    && apt-get clean \
    && echo 'sql_mode = TRADITIONAL' >> /etc/mysql/mysql.conf.d/mysqld.cnf \
    && cabal update \
    && curl -sLo /root/shellcheck-master.zip 'https://github.com/koalaman/shellcheck/archive/master.zip' \
    && cd /root \
    && unzip shellcheck-master.zip \
    && cd shellcheck-master \
    && cabal install \
    && mv /root/.cabal/bin/shellcheck /usr/local/bin \
    && apt-get autoremove -y ghc cabal-install \
    && curl -sLo /usr/local/bin/deployer 'https://deployer.org/deployer.phar' \
    && chmod +x /usr/local/bin/deployer \
    && rm -rf /root/shellcheck-master* /root/.cabal /root/.ghc /root/composer /root/mysql-apt-config.deb /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY "find-sh-run-shellcheck" "/usr/local/bin/find-sh-run-shellcheck"
RUN chmod 0755 /usr/local/bin/find-sh-run-shellcheck

COPY "php.ini" "/usr/local/etc/php/php.ini"
RUN cp /usr/share/zoneinfo/Europe/Rome /etc/localtime
