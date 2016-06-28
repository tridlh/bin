#!/bin/bash

# ssinstall.sh
# Install proxy, load ~/bin and ~/.bashrc
# Copyright (c) Lu, Han <tridlh@gmail.com>

STOREDIR=~/"store"

# proxy: shadowsocks and privoxy
sudo apt update
sudo apt install -y -f python-gevent python-pip python-m2crypto \
	     python-wheel python-setuptools
sudo -H pip install shadowsocks
sudo cp $STOREDIR/shadowsocks.json /etc
sudo sslocal -c /etc/shadowsocks.json &

sudo apt install -y -f privoxy
sudo cp $STOREDIR/privoxy/config /etc/privoxy
sudo /etc/init.d/privoxy start
export http_proxy="127.0.0.1:8118"
export https_proxy="127.0.0.1:8118"

rm index.html
wget http://www.google.com
if [ -f index.html ]; then
	echo "Proxy set succeed!"
else
	echo "Proxy set fail!"
	exit 1
fi

# ~/bin tools
tar Pxvf $STOREDIR/bin.tgz
# ~/.bashrc
cp $STOREDIR/.bashrc ~
