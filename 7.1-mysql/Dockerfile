FROM chialab/php:7.1

# Install PHP extensions and PECL modules.
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server mysql-client --no-install-recommends \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
