FROM ubuntu:14.04

MAINTAINER Markus Weiland <mw@graph-ix.net>

RUN apt-get update && apt-get install -y supervisor

ADD supervisord.conf /etc/supervisor/conf.d/

########

RUN apt-get install -y nginx

ADD nginx/nginx.conf /etc/nginx/
ADD nginx/app.conf /etc/nginx/sites-available/
ADD nginx/upstream.conf /etc/nginx/conf.d/upstream.conf
ADD nginx/fastcgi_params /etc/nginx/

RUN ln -s /etc/nginx/sites-available/app.conf /etc/nginx/sites-enabled/app
RUN rm /etc/nginx/sites-enabled/default

########

RUN apt-get install -y php5-common php5-cli php5-fpm php5-mcrypt php5-mysql php5-apcu php5-gd php5-imagick php5-curl php5-intl
RUN php5enmod mcrypt

RUN rm /etc/php5/fpm/pool.d/www.conf

ADD fpm/app.ini /etc/php5/fpm/conf.d/
ADD fpm/app.ini /etc/php5/cli/conf.d/
ADD fpm/app.pool.conf /etc/php5/fpm/pool.d/

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
