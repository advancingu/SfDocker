#
# Exposes a volume with application code to 
# the server containers (PHP, Nginx).
#
# This container is for production environments 
# into which application code statically baked.
#
# See "app-code-dynamic" for the development equivalent.
#

FROM ubuntu:14.04

MAINTAINER Markus Weiland <mw@graph-ix.net>

CMD mkdir -p /var/www/symfony
ADD code.tar.gz /var/www/symfony

VOLUME /var/www/symfony

