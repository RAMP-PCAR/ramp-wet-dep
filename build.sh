#!/bin/bash

wetCore="https://github.com/wet-boew/wet-boew.git#4.0.5"

# enable error reporting to the console, just in case
set -e

# only proceed script when started not by pull request (PR)
if [ $TRAVIS_PULL_REQUEST == "true" ]; then
    echo "this is PR, exiting"
    exit 0
fi

# ignore tags
if [ ! -z $TRAVIS_TAG ]; then
    echo "this is a tag, exiting"
    exit 0
fi

git clone -b $wetCore

cd web-boew

npm install

grunt