#!/bin/bash

# Ubuntu 14.04 dev install script
#
# This script should take a clean ubuntu 14.04 install
# and install all the necessary dependencies to have
# a working Symfony development environment.
#
# Run this script as your unprivileged user (ubuntu or yourname)

set -e
set -vx

DOCKER_COMPOSE_VERSION=1.1.0-rc2

# Needed for some Symfony CLI commands
if [ ! -f /usr/bin/mysql ]; then
    echo "Installing MySQL command line client."
    sudo apt-get install -y mysql-client-5.6
fi

# Extended file system Access Control List support
if [ ! -f /usr/bin/setfacl ]; then
    echo "Installing extended Access Control List support."
    sudo apt-get install -y acl
fi

# Support for running PHP on the Command Line
if [ ! -f /usr/bin/php ]; then
    echo "Installing PHP command line support."
    sudo apt-get install -y php5-cli
fi

if [ ! -f /usr/bin/curl ]; then
    echo "Installing curl utility."
    sudo apt-get install -y curl
fi

# Default folder in Ubuntu for small user-installed applications
if [ ! -d ~/bin ]; then
    echo "Creating ~/bin."
    mkdir ~/bin
fi

# Docker management tool, formerly known as Fig
if [ ! -e ~/bin/docker-compose ]; then
    echo "Installing docker-compose (aka Fig)."
    curl -L https://github.com/docker/fig/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-Linux-x86_64 > ~/bin/docker-compose
    chmod +x ~/bin/docker-compose
fi

# Command line PHP test runner
if [ ! -e ~/bin/phpunit ]; then
    echo "Installing PHPunit."
    curl -L https://phar.phpunit.de/phpunit.phar > ~/bin/phpunit
    chmod +x ~/bin/phpunit
fi

# PHP Composer package manager
if [ ! -f ~/bin/composer ]; then
    echo "Installing PHP composer."
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/home/$USER/bin --filename=composer
fi

# Docker container service
if [ ! -f /usr/bin/docker ]; then
    echo "Installing Docker."
    curl -s https://get.docker.io/ubuntu/ | sudo sh
fi

# Remove need for sudo when using docker; needs desktop relogin to become effective
if groups "$USER" | grep -q -v -E ' docker(\s|$)'; then
    echo "Adding your user to 'docker' group, removing the need for using 'sudo' with docker."
    sudo usermod -a -G docker $USER
    echo "Your user accounts's group membership has been changed. Please log out from your user account, log back in to activate the changes, and then run this script again."
    exit 0
fi


# Build the Docker images
echo "Building Docker images."
docker build -t symfony/app app
docker build -t symfony/app-dev app-dev
docker build -t symfony/app-code app-code
docker build -t symfony/nginx nginx
docker build -t symfony/nginx-dev nginx-dev


# Give the user and web server group full write access to all given directories
echo "Make log folders writable for web server group."
for WRITABLE_FOLDER in var/nginx
do
    mkdir -p ${WRITABLE_FOLDER}

    # set permission for existing files
    setfacl -R -m g:www-data:rwX -m u:$USER:rwX ${WRITABLE_FOLDER}

    # set default permissions for future files
    setfacl -dR -m g:www-data:rwX -m u:$USER:rwX ${WRITABLE_FOLDER}
done

echo "Don't forget to run  manually run the following commands in your Symfony project folder before accessing the project:"
echo "setfacl -R -m g:www-data:rwX -m u:$USER:rwX app/cache app/logs web/assets"
echo "setfacl -dR -m g:www-data:rwX -m u:$USER:rwX app/cache app/logs web/assets"

