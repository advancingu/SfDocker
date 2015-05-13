#!/bin/bash

# Bakes the application code into a Docker image "symfony/worker-prod".
# Simply deploy this image to your production servers.

set -e
set -xv

COMPOSER_BIN=composer
BUILD_DIR=/tmp/app-code-build
# Modify to your needs
REPOSITORY=git@github.com:symfony/symfony-standard.git
BRANCH=2.6
DOCKERFILE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Clean up old build files
if [ -d ${BUILD_DIR} ]; then
    echo "Removing ${BUILD_DIR}."
    rm -rf ${BUILD_DIR}
fi

# Get the code
mkdir ${BUILD_DIR}
cd ${BUILD_DIR}
git clone ${REPOSITORY}
CODE_DIR="$(ls -d */|head -n 1)"
cd ${CODE_DIR}
git checkout ${BRANCH}
rm -rf ${BUILD_DIR}/${CODE_DIR}.git

# Get dependencies with Composer
${COMPOSER_BIN} --no-interaction install

# Clear the cache so we don't have the build environment spill into production
# TODO pre-warm with production environment instead
app/console cache:clear --no-warmup

# Package everything up
tar -czf ../code.tar.gz *

# Put the package into our Docker build directory
cd ..
cp code.tar.gz ${DOCKERFILE_DIR}

# Build the Docker image
echo "Building static application code image."
cd ${DOCKERFILE_DIR}
docker build -t symfony/worker-prod ${DOCKERFILE_DIR}

rm ${DOCKERFILE_DIR}/code.tar.gz
