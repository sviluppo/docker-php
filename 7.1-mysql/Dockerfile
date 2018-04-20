FROM chialab/php:7.1

RUN \
    apt-get update \
    && apt-get install -y wget psmisc lsb-release \
    && curl -sLo /root/mysql-apt-config.deb https://dev.mysql.com/get/mysql-apt-config_0.8.9-1_all.deb \
    && dpkg -i /root/mysql-apt-config.deb \
    && echo 'deb http://repo.mysql.com/apt/debian/ jessie mysql-5.7' >> /etc/apt/sources.list.d/mysql.list \
    && echo 'deb-src http://repo.mysql.com/apt/debian/ jessie mysql-5.7' >> /etc/apt/sources.list.d/mysql.list \
    && echo 'deb http://ftp.debian.org/debian/ jessie-backports main' >> /etc/apt/sources.list.d/backports.list \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-community-server mysql-community-client \
    && apt-get -t jessie-backports install -y ghc cabal-install zip unzip \
    && apt-get clean \
    && echo 'sql_mode = TRADITIONAL' >> /etc/mysql/mysql.conf.d/mysqld.cnf \
    && cabal update \
    && cd /root \
    && wget --content-disposition 'https://github.com/koalaman/shellcheck/archive/master.zip' \
    && unzip shellcheck-master.zip \
    && cd shellcheck-master \
    && cabal install \
    && mv /root/.cabal/bin/shellcheck /usr/local/bin \
    && cd /root \
    && rm -rf shellcheck-master* .cabal .ghc \
    && apt-get autoremove -y ghc cabal-install \
    && rm -rf /root/mysql-apt-config.deb /var/lib/apt/lists/* /tmp/* /var/tmp/*
