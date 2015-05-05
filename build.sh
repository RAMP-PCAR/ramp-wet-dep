#!/bin/bash

wet="https://github.com/wet-boew/wet-boew.git tags/"
wet_v="v4.0.5"

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

git clone $wet$wet_v

cd tags/$wet_v

npm install

grunt