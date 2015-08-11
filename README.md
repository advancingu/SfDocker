Docker containers for Symfony development & production
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

There is a `worker-dev` development image that extends `worker-base` and adds development functionality such as Xdebug 
and turns on PHP debug output. The image also sets Nginx's configuration to load `web/app_dev.php` instead 
of `web/app.php`. This development image expects application files to be mounted into the container to 
`/var/www/app` from the host which means any code changes will immediately take effect.

There is a `worker-prod` production image that extends `worker-base` and simply bakes a Symfony project 
into the container. This image can be easily deployed as an immutable throwaway instance of the entire
application. This image should be built by executing `worker-prod/build-release.sh`.

Configuration
-------------

Container environment variables are used to adapt application behavior to the respective environment.

Add a `app/config/parameters.php` file to your project and include it after `app/config/parameters.yml`
in your configuration file:

```yaml
# app/config/config.yml
imports:
    - { resource: parameters.yml }
    - { resource: parameters.php }

# ...
```

In `parameters.php`, set Symfony parameters from environment variables as follows:

```php
// app/config/parameters.php
$parameters = [
    // ENV_VAR_NAME => symfony parameter name
    'DB_1_PORT_3306_TCP_ADDR' => 'database_host',
    'DB_1_PORT_3306_TCP_PORT' => 'database_port',
    'DB_1_ENV_MYSQL_DATABASE' => 'database_name',
    'DB_1_ENV_MYSQL_USER' => 'database_user',
    'DB_1_ENV_MYSQL_PASSWORD' => 'database_password',
    // ...
];

foreach ($parameters as $envVar => $sfParam) {
    $value = getenv($envVar);
    if ($value !== false && $value !== '') {
        $container->setParameter($sfParam, $value);
    }
}
```

Note: All environment variables which are to be used as parameters need to be 
defined in `worker-base/fpm/app.pool.conf`, otherwise they will not be
visible to PHP code.

Running app/console
-------------------

To have Symfony's ``app/console`` utility work as expected, it needs to be run from inside the container so 
that all environment variables are available for Symfony.

Simply execute the following from the path of this repository:

    docker-compose run worker /var/www/app/app/console

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
