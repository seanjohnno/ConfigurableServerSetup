#!/bin/bash

COMPLETED=$(cat /etc/nginx/sites-available/default | grep "# managed by Certbot")
if [ -z "${COMPLETED}" ]; then
    echo "Setting up nginx and letsencrypt"

    # Setup log dir
    mkdir -p /usr/share/nginx/logs/

    # Need to setup log format as access_log used in nginx.tpl
    cp ./configApp/log_format.conf /etc/nginx/conf.d/log_format.conf

    # Remove config so we can rebuild
    rm /etc/nginx/sites-available/default

    # Clone and run the project as a docker container
    CERTBOT_DOMAINS=""
    HOST_PORT=4000
    for hostConfig in ./configHosts/*; do
        source $hostConfig
        ./utility/clone_build_run.sh
        
        # Add serverblock to nginx config
        envsubst '${DOMAINS},${NAME},${HOST_PORT}' \
            < ./configApp/nginx.tpl \
            >> /etc/nginx/sites-available/default

        # Increment port
        HOST_PORT=$((HOST_PORT + 1))

        for domain in $DOMAINS; do
            CERTBOT_DOMAINS="$CERTBOT_DOMAINS -d $domain"
        done
    done

    # Reload nginx
    sudo systemctl reload nginx

    # LetsEncrypt / Cerbot
    sudo certbot --nginx --redirect $CERTBOT_DOMAINS
else
    echo "Already setup nginx and letsencrypt"
fi