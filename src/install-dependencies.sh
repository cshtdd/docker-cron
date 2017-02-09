#!/bin/sh

apt-get update && apt-get install curl -y
curl -sL https://deb.nodesource.com/setup_6.x | bash -
apt-get install -y nodejs
