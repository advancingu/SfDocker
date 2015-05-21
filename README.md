Docker containers for Symfony development & deployment
======================================================

This repository provides Dockerfiles for setting up ready to use Symfony development and production environments.

The configuration used in this repository makes use of Docker's layered image approach in the sense that the development 
environment image is simply an additional layer on top of the base image of the production environment.
This means your development environment will be practically identical to the production environment.

Production images built from this repository are immutable and can be easily deployed to off-the-shelf Docker instances with 
all application code, dependencies, folders, etc. already included.

Structure
---------

There is a `worker-base` image file that contains PHP-FPM and NGINX. Both processes expect a Symfony project at
`/var/www/app` at runtime inside the container.

There is a `worker-dev` images that extends `worker-base` that adds development functionality such as Xdebug 
and turns on PHP debug output. The image also sets Nginx's configuration to load `web/app_dev.php` instead 
of `web/app.php`. This development image expects application files to be mounted into the container to 
`/var/www/app` from the host which means any code changes will immediately take effect.

There is a `worker-prod` production image that extends `worker-base` and simply bakes a Symfony project 
into the container. This image can be easily deployed as an immutable throwaway instance of the entire
application. This image should be built by executing `worker-prod/build-release.sh`.

Container environment variables are used to adapt application behavior to the respective environment.
Simply add a `app/config/parameters.php` file to your project and include it after `app/config/parameters.yml`
in your `app/config/config.yml` file. Inside `parameters.php`, load parameters as follows:

    <?php

    if (getenv('MY_ENV_VAR') !== false) {
        $container->setParameter('my_parameter', getenv('MY_ENV_VAR'));
    }

    // ...

Running app/console
-------------------

You can run Symfony's ``app/console`` utility from inside the container or from your host environment.

### Inside the container

The advantage of running ``app/console`` inside the container is that the runtime environment will be exactly that 
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

To build the development images, run the following commands in the repository's top folder:

    docker build -t symfony/worker-base worker-base
    docker build -t symfony/worker-dev worker-dev

Then simply launch the development server with

    docker-compose up

To build a production image, run the following command in the repository's top folder:

    ./worker-prod/build-release.sh

Authors
-------

* Markus Weiland (@advancingu)
* Scott Wilson (@scooterXL)
