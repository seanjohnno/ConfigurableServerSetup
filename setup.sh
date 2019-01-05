#!/bin/bash

# --------------------------------------------------------------------------------------------------------------
# Hardening instructions taken from various sources:
#
#   https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-16-04
#   https://www.digitalocean.com/community/questions/best-practices-for-hardening-new-sever-in-2017
#   1 - https://www.howtoforge.com/tutorial/how-to-setup-automatic-security-updates-on-ubuntu-1604/
#   2 - https://www.linode.com/docs/security/using-fail2ban-for-security/
#   https://www.digitalocean.com/community/tutorials/how-to-set-up-time-synchronization-on-ubuntu-16-04
#   https://www.techrepublic.com/article/how-to-harden-ubuntu-server-16-04-security-in-five-steps/
#   https://www.thefanclub.co.za/how-to/how-secure-ubuntu-1604-lts-server-part-1-basics
# --------------------------------------------------------------------------------------------------------------

# Environment vars
source ./config.sh

# Adding docker repository + setting cache policy to get docker from new repo
DOCKER_REPO_INSTALLED=$(find /etc/apt/ -name *.list | xargs cat | grep "https://download.docker.com/linux/ubuntu" | grep -v "#")
if [ -z "$DOCKER_REPO_INSTALLED" ]; then
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
    apt-cache policy docker-ce
fi

# Letsencrypt repository
CERTBOT_REPO_INSTALLED=$(find /etc/apt/ -name *.list | xargs cat | grep "http://ppa.launchpad.net/certbot/certbot/ubuntu" | grep -v "#")
if [ -z "$CERTBOT_REPO_INSTALLED" ]; then
    sudo add-apt-repository ppa:certbot/certbot
fi

# Update and upgrade packages
apt-get update && apt-get upgrade -y

# Install required packages (for our stack)
./utility/idempotent_install.sh "sendmail" "unattended-upgrades" "fail2ban" \
    "apt-transport-https" "ca-certificates" "curl" "software-properties-common" \
    "docker-ce" "nginx" "python-certbot-nginx" "envsubst"

# Set UTC timezone and sync
timedatectl set-timezone UTC
timedatectl set-ntp on

# Turn on firewall (allow ssh/sendmail/docker out)
sudo ufw allow OpenSSH
sudo ufw limit 22/tcp
sudo ufw allow out 25
sudo ufw allow out 443
sudo ufw allow 'Nginx Full'
sudo ufw delete allow 'Nginx HTTP'
sudo ufw --force enable

# System hardening
./utility/system_hardening.sh

# unattended-upgrades setup
sudo rm -f /etc/apt/apt.conf.d/50unattended-upgrades
envsubst '${UNATTENDED_UPGRADES_SENDTO_EMAIL},${UNATTENDED_UPGRADES_UPDATE_TIME}' \
    < ./configApp/50unattended-upgrades.tpl \
    > /etc/apt/apt.conf.d/50unattended-upgrades

# Fail2Ban setup
sudo rm -f /etc/fail2ban/jail.local
envsubst '${FAIL2BAN_SENDTO_EMAIL},${FAIL2BAN_SENDTO_EMAIL},${FAIL2BAN_SENDER_EMAIL}' \
    < ./configApp/jail.local.tpl \
    > /etc/fail2ban/jail.local

# Add to bitbucket/github to known hosts
sudo ./utility/add_to_known_hosts.sh "github.com" "bitbucket.org"

# Add a postgres container
if [ "$BUILD_AND_RUN_POSTGRES" = "yes" ] && [ -z $(docker ps | grep postgres) ]; then
    docker run \
        --name $POSTGRES_CONTAINER_NAME \
        -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD \
        -d postgres
fi

# Create nginx config & setup letsencrypt
./utility/setup_nginx.sh

# Reboot required to make some of the changes take effect
reboot &
