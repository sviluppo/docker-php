FROM chialab/php:7.1

RUN \
    apt-get update \
    && apt-get install -y wget psmisc lsb-release zip unzip libc-client-dev libkrb5-dev \
    && docker-php-ext-configure imap --with-imap --with-imap-ssl --with-kerberos \
    && docker-php-ext-install imap \
    && curl -sLo /root/mysql-apt-config.deb 'https://dev.mysql.com/get/mysql-apt-config_0.8.9-1_all.deb' \
    && dpkg -i /root/mysql-apt-config.deb \
    && echo 'deb http://repo.mysql.com/apt/debian/ jessie mysql-5.7' >> /etc/apt/sources.list.d/mysql.list \
    && echo 'deb-src http://repo.mysql.com/apt/debian/ jessie mysql-5.7' >> /etc/apt/sources.list.d/mysql.list \
    && echo 'deb http://ftp.debian.org/debian/ jessie-backports main' >> /etc/apt/sources.list.d/backports.list \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-community-server mysql-community-client \
    && apt-get -t jessie-backports install -y ghc cabal-install \
    && apt-get clean \
    && echo 'sql_mode = TRADITIONAL' >> /etc/mysql/mysql.conf.d/mysqld.cnf \
    && cabal update \
    && curl -sLo /root/shellcheck-master.zip 'https://github.com/koalaman/shellcheck/archive/master.zip' \
    && cd /root \
    && unzip shellcheck-master.zip \
    && cd shellcheck-master \
    && cabal install \
    && mv /root/.cabal/bin/shellcheck /usr/local/bin \
    && curl -sLo /usr/local/bin/find-sh-run-shellcheck 'https://raw.githubusercontent.com/Slamdunk/docker-php-mysql/master/find-sh-run-shellcheck' \
    && chmod 0755 /usr/local/bin/find-sh-run-shellcheck \
    && apt-get autoremove -y ghc cabal-install \
    && rm -rf /root/shellcheck-master* /root/.cabal /root/.ghc /root/composer /root/mysql-apt-config.deb /var/lib/apt/lists/* /tmp/* /var/tmp/*
