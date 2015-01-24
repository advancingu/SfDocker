#!/bin/bash

echo "upstream php-upstream { server php:${PHP_1_PORT_9000_TCP_PORT}; }" \
    > /etc/nginx/conf.d/upstream.conf

# run nginx
nginx

