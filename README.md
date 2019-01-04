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
