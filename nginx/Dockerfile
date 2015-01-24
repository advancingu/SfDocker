FROM ubuntu:14.04

MAINTAINER Markus Weiland <mw@graph-ix.net>

RUN apt-get update && apt-get install -y nginx

ADD nginx.conf /etc/nginx/
ADD symfony.conf /etc/nginx/sites-available/
RUN ln -s /etc/nginx/sites-available/symfony.conf /etc/nginx/sites-enabled/symfony

RUN rm /etc/nginx/sites-enabled/default

ADD run-nginx.sh /usr/sbin/run-nginx.sh

EXPOSE 80
CMD ["/usr/sbin/run-nginx.sh"]

