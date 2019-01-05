#!/bin/bash

# Start ssh agent
eval $(ssh-agent -s)

for host in "$@"
do
    ALREADY_SAVED=$(cat ~/.ssh/saved_hosts | grep -F "${host}")
    if [ -z "${ALREADY_SAVED}" ]; then
        echo "Adding $host to ~/.ssh/known_hosts"
        ssh-keyscan -t rsa -H "$host" >> ~/.ssh/known_hosts
        echo $host >> ~/.ssh/saved_hosts
    else
        echo "$host already in ~/.ssh/known_hosts"
    fi
done
