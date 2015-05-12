FROM ubuntu:14.04

MAINTAINER Markus Weiland <mw@graph-ix.net>

RUN apt-get update && apt-get install -y supervisor

ADD supervisord.conf /etc/supervisor/conf.d/

########

RUN apt-get install -y nginx

ADD nginx/nginx.conf /etc/nginx/
ADD nginx/symfony.conf /etc/nginx/sites-available/
ADD nginx/upstream.conf /etc/nginx/conf.d/upstream.conf

RUN ln -s /etc/nginx/sites-available/symfony.conf /etc/nginx/sites-enabled/symfony
RUN rm /etc/nginx/sites-enabled/default

########

RUN apt-get install -y php5-common php5-cli php5-fpm php5-mcrypt php5-mysql php5-apcu php5-gd php5-imagick php5-curl php5-intl
RUN php5enmod mcrypt

RUN rm /etc/php5/fpm/pool.d/www.conf

ADD fpm/symfony.ini /etc/php5/fpm/conf.d/
ADD fpm/symfony.ini /etc/php5/cli/conf.d/
ADD fpm/symfony.pool.conf /etc/php5/fpm/pool.d/

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
