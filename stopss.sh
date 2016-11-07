#!/bin/bash
# Stop shadowsocks and privoxy services
pkill -9 sslocal
sudo /etc/init.d/privoxy stop
export http_proxy=""
export https_proxy=""
