FROM symfony/worker-base

MAINTAINER Markus Weiland <mw@graph-ix.net>

########

ADD nginx/app.conf /etc/nginx/sites-available/

# Allow debugging PHP scripts with Xdebug for 10 minutes before Nginx times out
RUN echo "fastcgi_read_timeout 600s;" >> /etc/nginx/fastcgi_params

########

RUN apt-get install -y php5-xdebug && php5enmod xdebug
ADD fpm/20-xdebug.ini /etc/php5/fpm/conf.d/
ADD fpm/20-xdebug.ini /etc/php5/cli/conf.d/

ADD fpm/app.ini /etc/php5/fpm/conf.d/
ADD fpm/app.ini /etc/php5/cli/conf.d/

ENV XDEBUG_HOST 127.0.0.1
ENV XDEBUG_PORT 9000
ENV XDEBUG_REMOTE_MODE jit
ENV XDEBUG_CONNECT_BACK 0

EXPOSE 9000
