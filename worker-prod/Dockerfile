FROM symfony/worker-base

MAINTAINER Markus Weiland <mw@graph-ix.net>

########

RUN mkdir -p /var/www/symfony
ADD code.tar.gz /var/www/symfony

RUN chown -R www-data:www-data /var/www/symfony/app/cache /var/www/symfony/app/logs
