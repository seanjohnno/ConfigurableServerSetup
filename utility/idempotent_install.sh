#!/bin/bash

# Install all packages we want
for package in "$@"
do
    isInstalled=$(sudo apt list "$package" | grep "\[installed\]")
    if [ -z "$isInstalled" ]; then
        echo "Installing $package..."
        sudo apt install -y $package
    else
        echo "$package already installed, skipping"
    fi
done
