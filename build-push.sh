#!/bin/sh

DOCKERUSER=junhochoi
DOCKERNAME=quiche-docker-examples

for dir in simple nginx curl
do
    FULLTAGNAME="$DOCKERUSER"/"$DOCKERNAME":"$dir"
    TAGNAME="$DOCKERNAME":"$dir"
    echo ">> Building $TAGNAME ..."
    cd $dir
    docker build -t $TAGNAME .
    echo ">> Pushing $FULLTAGNAME ..."
    docker tag $TAGNAME $FULLTAGNAME
    docker push $FULLTAGNAME
    cd ..
done
