#!/bin/bash

set -x

# fail on any error
set -o errexit

apt-get update

wget -qO- https://raw.githubusercontent.com/neam/dokku/awaiting-prs/bootstrap.sh | DOKKU_REPO="https://github.com/neam/dokku.git" DOKKU_BRANCH="awaiting-prs" bash

cd /var/lib/dokku/plugins
git clone https://github.com/kristofsajdak/dokku-registry
dokku plugins-install