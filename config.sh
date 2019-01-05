#!/bin/bash

export UNATTENDED_UPGRADES_SENDTO_EMAIL="youremail@email.com" # Unattended upgrade updates are sent here
export UNATTENDED_UPGRADES_UPDATE_TIME="now" # Can be "now" or 24hr time e.g. "10:00"

export FAIL2BAN_SENDTO_EMAIL="youremail@email.com" # Fail2Ban updates sent to this email 
export FAIL2BAN_SENDER_NAME="Fail2Ban" # Sender name
export FAIL2BAN_SENDER_EMAIL="fail2ban@yourdomain.com" # Sender email

export BUILD_AND_RUN_POSTGRES="yes" # "no" to not build the postgres container (if you don't need it)
export POSTGRES_CONTAINER_NAME="postgresDb" # TODO - Shouldn't matter, get rid of this
export POSTGRES_PASSWORD="" # Create a password

export PYTHON="python3" # Version of python on system