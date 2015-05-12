FROM symfony/worker-base

MAINTAINER Markus Weiland <mw@graph-ix.net>

########

RUN sudo apt-get install -y acl

RUN mkdir -p /var/www/symfony
ADD code.tar.gz /var/www/symfony

RUN setfacl -R -m g:www-data:rwX /var/www/symfony/app/cache /var/www/symfony/app/logs
RUN setfacl -dR -m g:www-data:rwX /var/www/symfony/app/cache /var/www/symfony/app/logs
