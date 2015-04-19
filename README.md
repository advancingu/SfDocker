Docker containers for Symfony development
=========================================

This repository provides a build script and Dockerfiles for setting up a complete Symfony development environment.

The goal is to allow this setup to be easily deployed to production by stripping off dev-specific Docker images.

This repository is still in early development. Feel free to contribute.

![Container structure](https://raw.github.com/advancingu/SfDocker/master/Resources/container-structure.png)

Running app/console
-------------------

You can run Symfony's ``app/console`` utility from inside the PHP container or from your host environment.

### Inside the PHP container

The advantage of running ``app/console`` inside the PHP container is that the runtime environment will be exactly that 
the application code will run in when called by Nginx. The disadvantage is that all files created by ``app/console`` 
will be owned by ``root/root`` on the host filesystem.

### In the host environment

The advantage of running ``app/console`` in the host environment is that all files created are owned by the current 
user. The disadvantage is that the runtime environment will be different from the production environment and database 
parameters are different from those inside the containers.

To allow your host environment ``app/console`` to connect to the database, create a new Symfony environment ``cli``.

    # app/config/config_cli.yml
    imports:
        - { resource: config_dev.yml }
        - { resource: parameters_cli.yml }


    # app/config/parameters_cli.yml
    # Parameters for running app/console from outside of Docker container
    parameters:
        database_driver: pdo_mysql
        database_host: 127.0.0.1
        database_port: null
        database_name: symfony
        database_user: root
        database_password: symfonyrootpass

Then run ``app/console`` with ``--env=cli`` to use parameters from this new environment.

Building SfDocker images
------------------------

To build the Docker images, run the following commands in the repository's top folder:

    docker build -t symfony/php php
    docker build -t symfony/php-dev php-dev
    docker build -t symfony/app-code-dynamic app-code-dynamic
    docker build -t symfony/nginx nginx
    docker build -t symfony/nginx-dev nginx-dev

Authors
-------

This repository was built by Markus Weiland (@advancingu) with significant contributions to the base design and code by Scott Wilson (@scooterXL).

