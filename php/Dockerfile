FROM ubuntu:14.04
MAINTAINER Markus Weiland <mw@graph-ix.net>

RUN apt-get update && apt-get install -y php5-common php5-cli php5-fpm php5-mcrypt php5-mysql php5-apcu php5-gd php5-imagick php5-curl php5-intl
RUN php5enmod mcrypt

RUN rm /etc/php5/fpm/pool.d/www.conf

ADD symfony.ini /etc/php5/fpm/conf.d/
ADD symfony.ini /etc/php5/cli/conf.d/
ADD symfony.pool.conf /etc/php5/fpm/pool.d/

ADD run-php.sh /usr/sbin/run-php.sh

EXPOSE 9000
CMD ["/usr/sbin/run-php.sh"]

