#!/bin/bash

eval $(ssh-agent -s)

for sshKey in ./sshKeys/*; do
    KEY=$(echo $sshKey | grep -v "\.pub")
    if [ ! -z $KEY ]; then
        chmod 600 $KEY
        ssh-add $KEY
    fi
done

if [ -d "$NAME" ]; then
    pushd "./$NAME"
        git pull
    popd
else
    git clone $GIT_REPOSITORY $NAME
fi

pushd "./$NAME"
    docker build --tag $NAME .
    HOST_PORT=$($PYTHON ../utility/nginx_current_port_by_domain.py /etc/nginx/sites-available/default "$DOMAINS")
    if [ -f "./Dockerrun" ]; then
        RUN_CMD=$(envsubst '${HOST_PORT}' < './Dockerrun')
        $RUN_CMD
    else
        docker run -d -p $HOST_PORT:$PORT --restart always $NAME
    fi
popd
