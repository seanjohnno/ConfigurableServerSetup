## Not quite ready yet - Come back soon

### What is it?

Attempts to create a secure* web server with an NGINX, Postgres and Docker stack. You point it at your git repository(s) and it pulls, builds and runs it as a container, reverse proxying through NGINX. It'll also automatically setup HTTPS for you using LetsEncrypt. You can host multiple domains on the same server should you so choose.

### Why?

It allows you to focus on development in whatever language you choose and not have to worry about server configuration and ops. It's provider agnostic so you can keep costs low and predictable with $5 per month VPS providers.

### *Secure?

I'd welcome feedback and improvements on this but the scripts do the following (advice mainly taken from [here](https://www.digitalocean.com/community/questions/best-practices-for-hardening-new-sever-in-2017)):

* Disable shared memory
* Harden the network layer
* Perform security upgrades at a time of your choosing
* Setup Fail2Ban
* Enables firewall and only allows ports for OpenSSH (22 in), SMTP (25 out), Docker (443 out), NGINX (80, 443 in)

### Getting started

#### 1. Setup
* Create a new key/pair but name it, don't use the default. You can find how to [here](https://help.github.com/enterprise/2.15/user/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/)
* Add your new key to your git account, if possible just give it read access to the repository(s) you'll be running on your web server
* In your git repository(s) make sure the Dockerfile is at the root
* Clone this repository

#### 2. Configuration
* Drop your newly created private key in the *sshKeys/* directory
* For each domain you'll be using, create a new *yourdomain.sh* file in *configHosts/*. Remove/edit *exampleDomain.sh*:
  * *NAME* can be anything you like
  * *PORT* should be the port your container is using to serve web traffic (usually matching an EXPOSE statement in your Dockerfile)
  * *GIT_REPOSITORY* what you'd use to clone it
  * *DOMAINS* the domain name you're using and it's variations i.e. "www.mydomain.co.uk mydomain.co.uk"

#### 3. Server Creation (unsure about how to create/setup a server?)
* TODO

#### 4. Run
* Copy your modified version of this repository to the server: ```scp -r ./ root@<ip_address>:/tmp/setup```
* SSH into your server: ```ssh root@<ip_address>```
* Run the setup script: ```cd /tmp/setup; ./setup.sh```
* This will log you out of the session as the server reboots but after it's (auto) rebooted, you should be able to access your website with https://yourdomain

#### 5. Update *(You've been working hard, now you want your changes on the server)*
* SSH into your server: ```ssh root@<ip_address>```
* Run the update script: ```cd /tmp/setup; ./update.sh```
