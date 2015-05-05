#!/bin/bash

#apt-get install zip

# enable error reporting to the console, just in case
#set -e

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
#repos="wet-boew theme-gcwu-fegc theme-gc-intranet GCWeb"
repos="wet-boew"

ramp_dep="https://${GH_TOKEN}@github.com/RAMP-PCAR/ramp-wet-dep"

for r in $repos; do    
    # clone wet repo
    git clone $wet_base$r
    
    # build wet
	cd $r
    git checkout $wet_v
        #npm install
        #grunt
    
    # remove garbage
    rm -rf node_modules
    rm -rf lib
    rm bower.json
    rm package.json
    
    # zipping 
    cd ..
    zip -r $r$wet_v.zip $r
    ls
        
    rm -rf $r
    ls
    
    git checkout wet-boew
    
    git add -A .
    git commit -a -m "chore(grunt): ?"
    
    git push $ramp_dep
    #git push --quiet $targetRepo $targetBranch > /dev/null 2>&1 
done


# got back up a level
#cd ..

# clone our dep repo
#git clone -b wet-boew $dep_repo ramp-wet-dep

# cope 
#cp -R wet-boew/* ramp-wet-dep/wet