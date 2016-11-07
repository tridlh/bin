#!/bin/bash
# Start shadowsocks and privoxy services
if [ ! "$(pgrep "sslocal")" ]; then
	sslocal -c /etc/shadowsocks.json &
fi
if [ ! "$(pgrep "privoxy")" ]; then
	sudo /etc/init.d/privoxy start
	export http_proxy="127.0.0.1:8080"
	export https_proxy="127.0.0.1:8080"
fi
