FROM ubuntu:20.04

## Actualización del sistema
RUN apt-get update && apt-get -y upgrade

## Update system
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

## Preesed TZData
RUN echo "tzdata tzdata/Areas select America" > /tmp/preseed.txt; \
    echo "tzdata tzdata/Zones/America select Mexico_City" >> /tmp/preseed.txt; \
    debconf-set-selections /tmp/preseed.txt && \
    apt-get install -y tzdata

## Cleanup of files from setup
# RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

## Install Apache
RUN apt-get install -y apache2

## Install MariaDB
RUN apt-get install -y mariadb-server

## Install PHP 7.4
RUN apt-get install -y software-properties-common && add-apt-repository ppa:ondrej/php && apt-get update
RUN apt-get install -y php7.4 libapache2-mod-php7.4 php7.4-common php7.4-gmp php7.4-curl php7.4-intl php7.4-mbstring php7.4-xmlrpc php7.4-gd php7.4-xml php7.4-cli php7.4-zip php7.4-mysql

## Install utilities
RUN apt-get install -y git iputils-ping wget unzip curl nano

## Composer
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && chmod +x /usr/local/bin/composer

## Ports
EXPOSE 80
EXPOSE 3306

# Workdir
WORKDIR /var/www/html/

# Entrypoint
ENTRYPOINT service apache2 start && service mysql start && /bin/bash