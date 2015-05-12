FROM symfony/worker-base

MAINTAINER Markus Weiland <mw@graph-ix.net>

########

ADD nginx/symfony.conf /etc/nginx/sites-available/

########

RUN apt-get install -y php5-xdebug && php5enmod xdebug
ADD fpm/20-xdebug.ini /etc/php5/fpm/conf.d/

ADD fpm/symfony.ini /etc/php5/fpm/conf.d/
ADD fpm/symfony.ini /etc/php5/cli/conf.d/

ENV XDEBUG_HOST 127.0.0.1
ENV XDEBUG_PORT 9000
ENV XDEBUG_REMOTE_MODE jit
ENV XDEBUG_CONNECT_BACK 0

EXPOSE 9000

########

#WORKDIR /var/www/symfony
