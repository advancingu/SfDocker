#!/bin/bash

# Bakes the application code into a Docker image "app-code-static".
# Deploy this image to your production servers as a 
# replacement for "app-code-dynamic".

set -e
set -xv

COMPOSER_BIN=composer
BUILD_DIR=/tmp/app-code-build
REPOSITORY=git@github.com:symfony/symfony-standard.git
BRANCH=2.6
WORKING_DIR=$(pwd)
DOCKERFILE_DIR=${WORKING_DIR}/app-code-static

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

# Get dependencies with Composer
${COMPOSER_BIN} --no-interaction install

# Package everything up
tar -czf ../code.tar.gz *

# Put the package into our Docker build directory
cd ..
cp code.tar.gz ${DOCKERFILE_DIR}

# Build the Docker image
echo "Building static application code image."
cd ${WORKING_DIR}
docker build -t symfony/app-code-static app-code-static

