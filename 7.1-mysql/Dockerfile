FROM chialab/php:7.1

RUN \
    apt-get update \
    && apt-get install -y wget psmisc lsb-release \
    && curl -sLo /root/mysql-apt-config.deb https://dev.mysql.com/get/mysql-apt-config_0.8.9-1_all.deb \
    && dpkg -i /root/mysql-apt-config.deb \
    && echo 'deb http://repo.mysql.com/apt/debian/ jessie mysql-5.7' >> /etc/apt/sources.list.d/mysql.list \
    && echo 'deb-src http://repo.mysql.com/apt/debian/ jessie mysql-5.7' >> /etc/apt/sources.list.d/mysql.list \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-community-server mysql-community-client \
    && apt-get clean \
    && echo 'sql_mode = TRADITIONAL' >> /etc/mysql/mysql.conf.d/mysqld.cnf \
    && rm -rf /root/mysql-apt-config.deb /var/lib/apt/lists/* /tmp/* /var/tmp/*
