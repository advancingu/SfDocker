FROM symfony/worker-base

MAINTAINER Markus Weiland <mw@graph-ix.net>

########

RUN mkdir -p /var/www/app
ADD code.tar.gz /var/www/app

RUN chown -R www-data:www-data /var/www/app/app/cache /var/www/app/app/logs
