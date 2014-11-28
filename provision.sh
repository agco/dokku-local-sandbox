#!/bin/bash

set -x

# fail on any error
set -o errexit

sudo apt-get update
sudo apt-get install -y git make curl software-properties-common gcc

rm -rf dokku
git clone https://github.com/progrium/dokku.git
cd dokku
git fetch origin
sudo BUILD_STACK=true make install

# update nginx.conf to support longer than 46 character hostnames (default value 64 which equals 46 chars)

sudo sed -i 's/server_names_hash_bucket_size 64;/server_names_hash_bucket_size 128;/' /etc/nginx/nginx.conf
cat /etc/nginx/nginx.conf | grep server
/etc/init.d/nginx restart

# add a dokkurc file to easily turn on and off debug mode (https://github.com/progrium/dokku/wiki/Troubleshooting)

echo '#export DOKKU_TRACE=1' > /home/dokku/dokkurc

# add extra swap to make dokku more stable in oom situations (https://github.com/dotcloud/docker/issues/1555)

if [ ! -f "/var/swap.1" ]; then
    sudo /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=4096
    sudo /sbin/mkswap /var/swap.1
    sudo /sbin/swapon /var/swap.1
    echo '/var/swap.1 swap swap defaults 0 0' > /etc/fstab
fi

# install htop and mosh
sudo apt-get install -y -q htop mosh

# nsenter

if [ ! -f /usr/local/bin/nsenter ]; then
    cd /tmp
    curl https://www.kernel.org/pub/linux/utils/util-linux/v2.24/util-linux-2.24.tar.gz \
         | tar -zxf-
    cd util-linux-2.24
    ./configure --without-ncurses
    make nsenter
    sudo cp nsenter /usr/local/bin/
    sudo wget -qO- https://raw.githubusercontent.com/jpetazzo/nsenter/master/docker-enter > /usr/local/bin/docker-enter
    sudo chmod +x /usr/local/bin/docker-enter
fi


cd /var/lib/dokku/plugins

rm -rf dokku-registry
git clone https://github.com/agco-adm/dokku-registry
rm -rf dokku-docker-options
git clone https://github.com/dyson/dokku-docker-options.git

sudo dokku plugins-install

if sudo docker ps | grep "logspout" 
    then sudo docker stop logspout && sudo docker rm logspout
fi
sudo docker run -d -h $HOSTNAME --name logspout --restart=always -p 8000:8000 -v=/var/run/docker.sock:/tmp/docker.sock progrium/logspout $1
