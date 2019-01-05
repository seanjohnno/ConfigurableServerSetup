#!/bin/bash

# Disable shared memory
cp -f ./configSystem/fstab /etc/fstab

# Harden the network layer
cp -f ./configSystem/sysctl.conf /etc/sysctl.conf 

# IP spoofing and named.conf.options don't seem to be relevant anymore