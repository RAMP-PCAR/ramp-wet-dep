﻿#!/bin/bash

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

wet_v="v4.0.5"
wet_base="https://github.com/wet-boew/"
repos="wet-boew theme-gcwu-fegc theme-gc-intranet GCWeb"
#repos="wet-boew"

ramp_dep="https://${GH_TOKEN}@github.com/RAMP-PCAR/ramp-wet-dep"
ramp_folder="ramp_dep"
ramp_branch="dep"

git clone -b $ramp_branch $ramp_dep $ramp_folder

for r in $repos; do    
    # clone wet repo
    git clone $wet_base$r $r
    
    # build wet
	cd $r
    git checkout $wet_v
    npm install
    
    if [ $r == "wet-boew" ]; then
        grunt init
        grunt dist
    else
        grunt build
        grunt assets-dist
    fi
    
    # remove garbage
    rm -rf node_modules
    rm -rf lib
    rm -rf .git
    rm bower.json
    rm package.json
    
    # making folder to store archive in
    cd ..
    #mkdir -p $ramp_folder/$r
    mkdir -p $ramp_folder/$wet_v
    # remove previous file with the same version number if exists
    rm -f $ramp_folder/$wet_v/$r.zip
    
    # zipping 
    zip -r $ramp_folder/$wet_v/$r.zip $r
    ls
    
    # remove original wet repo 
    rm -rf $r
done

cd $ramp_folder

# add new files
git add -A .
git commit -a -m "chore(release): WET dependencies $wet_v"

# push them into the repo
#git push $ramp_dep
git push --quiet $ramp_dep > /dev/null 2>&1