#!/bin/bash

# envsync-store / envsync-load
# Store and reload current Ubuntu environment.
# Copyright (c) Han Lu <tridlh@gmail.com>

BINDIR=~/"bin"
STOREDIR=~/"store"

aptupd="sudo apt update"
aptins="sudo apt install -y -f"
aptdep="sudo apt build-dep -y -f"

storeconf_proxy () {
	echo ${FUNCNAME[0]}
	mkdir -p $STOREDIR
	# apt
#if [ -f /etc/apt/apt.conf ]; then
#	cp /etc/apt/apt.conf $STOREDIR
#fi
	# tsocks
#cp /etc/tsocks.conf $STOREDIR
	# vpn
#mkdir -p $STOREDIR/system-connections
#sudo cp /etc/NetworkManager/system-connections/* $STOREDIR/system-connections
	# shadowsocks
	sudo cp /etc/shadowsocks.json $STOREDIR
	# privoxy
	mkdir -p $STOREDIR/privoxy
	sudo cp /etc/privoxy/config $STOREDIR/privoxy
}

loadconf_proxy () {
	echo ${FUNCNAME[0]}
	if [ -d $STOREDIR ]; then
		# apt
#if [ -d $STOREDIR ]; then
#	if [ ! -f /etc/apt/apt.conf ]; then
#		sudo cp $STOREDIR/apt.conf /etc/apt/
#	fi
#else
#	echo "$STOREDIR does not exist!"
#fi
		# tsocks
#sudo cp $STOREDIR/tsocks.conf /etc
		# vpn
#sudo cp $STOREDIR/system-connections/* /etc/NetworkManager/system-connections
		# shadowsocks
		sudo cp $STOREDIR/shadowsocks.json /etc
		# privoxy
		sudo cp $STOREDIR/privoxy/config /etc/privoxy
		export http_proxy="127.0.0.1:8118"
		export https_proxy="127.0.0.1:8118"
	else
		echo "$STOREDIR does not exist!"
	fi
}

install_proxy () {
	echo ${FUNCNAME[0]}
	# tsocks
	$aptins tsocks
	# vpn
	# shadowsocks
	$aptins python-gevent python-pip
	sudo -H pip install shadowsocks
	# privoxy
	$aptins privoxy
	# load conf
	loadconf_proxy
}

storeconf_bashrc () {
	echo ${FUNCNAME[0]}
	mkdir -p $STOREDIR
	cp ~/.bashrc $STOREDIR
}

loadconf_bashrc () {
	echo ${FUNCNAME[0]}
	if [ -d $STOREDIR ]; then
		cp $STOREDIR/.bashrc ~
	else
		echo "$STOREDIR does not exist!"
	fi
}

store_bin () {
	echo ${FUNCNAME[0]}
	mkdir -p $STOREDIR
	if [ ! -f $STOREDIR/bin.tgz ]; then
		tar Pzcvf $STOREDIR/bin.tgz ~/bin
	fi
}

load_bin () {
	echo ${FUNCNAME[0]}
	if [ -d $STOREDIR ]; then
		if [ ! -d ~/bin ]; then
			tar Pxvf $STOREDIR/bin.tgz
		fi
	else
		echo "$STOREDIR does not exist!"
	fi
}

install_ssh () {
	echo ${FUNCNAME[0]}
	$aptins ssh sshfs
	cd ~
	if [ ! -f ~/.ssh/id_rsa.pub ]; then
		ssh-keygen -t rsa
	else
		echo "$STOREDIR does not exist!"
	fi
	if [ $# -eq 1 ]; then
		cat .ssh/id_rsa.pub | ssh $1 'cat >> .ssh/authorized_keys'
		ssh $1 'cat .ssh/id_rsa.pub' > .ssh/authorized_keys
		mount.sh
	fi
	cd -
}

workdir="`whoami`-work"

store_workdir () {
	echo ${FUNCNAME[0]}
	mkdir -p $STOREDIR
	if [ ! -f $STOREDIR/$workdir.tgz ]; then
		tar Pzcvf $STOREDIR/$workdir.tgz ~/work/$workdir
	fi
}

load_workdir () {
	echo ${FUNCNAME[0]}
	mkdir -p ~/work
	if [ -d $STOREDIR ]; then
		if [ ! -d ~/work/$workdir ]; then
			tar Pxvf $STOREDIR/$workdir.tgz
		else
			echo "$workdir is already existing."
		fi
	else
		echo "$STOREDIR does not exist!"
	fi
}

androidstudio="android-studio-ide-145.2949926-linux.zip"
androidconfig="android-config.tgz"
ANDROIDSTUDIODIR="/opt/android"

store_android () {
	echo ${FUNCNAME[0]}
	mkdir -p $STOREDIR
	# Android studio
	if [ ! -f $STOREDIR/$androidstudio ]; then
		find ~ -path $STOREDIR -prune -o -name $androidstudio \
			-exec mv -t $STOREDIR {} \;
	fi
	# Android config
	if [ ! -f $STOREDIR/$androidconfig ]; then
		tar Pzcvf $STOREDIR/$androidconfig ~/.android ~/Android \
			~/.AndroidStudio* ~/AndroidStudioProjects .gradle
	fi
}

load_android () {
	echo ${FUNCNAME[0]}
	if [ -d $STOREDIR ]; then
		# Android studio
		if [ ! -d $ANDROIDSTUDIODIR/android-studio ]; then
			sudo mkdir -p $ANDROIDSTUDIODIR
			sudo chown `whoami` $ANDROIDSTUDIODIR
			unzip $STOREDIR/$androidstudio -d $ANDROIDSTUDIODIR
		else
			echo "ANDROIDSTUDIODIR is already existing."
		fi
		# Android config
		if [ ! -d ~/Android ]; then
			tar Pxvf $STOREDIR/$androidconfig
		else
			echo "Android config files are already existing."
		fi
	else
		echo "$STOREDIR does not exist!"
	fi
}

install_general_tools () {
	echo ${FUNCNAME[0]}
	$aptins automake build-essential libtool
	$aptdep alsa-utils
	$aptins xutils-dev
	$aptdep xserver-xorg-dev
	$aptdep unity-control-center
	$aptins xserver-xorg-dev
	$aptins fcitx-googlepinyin
}

storeconf_vim () {
	echo ${FUNCNAME[0]}
	mkdir -p $STOREDIR
	cp ~/.vimrc $STOREDIR
}

loadconf_vim () {
	echo ${FUNCNAME[0]}
	if [ -d $STOREDIR ]; then
		cp $STOREDIR/.vimrc ~
	else
		echo "$STOREDIR does not exist!"
	fi
}

install_vim () {
	echo ${FUNCNAME[0]}
	$aptins vim vim-scripts vim-doc
	loadconf_vim
	vim-addons install taglist winmanager minibugexplorer project
	$aptins ctags
	$aptins cscope
}

storeconf_git () {
	echo ${FUNCNAME[0]}
	mkdir -p $STOREDIR
	cp ~/.gitconfig $STOREDIR
}

loadconf_git () {
	echo ${FUNCNAME[0]}
	if [ -d $STOREDIR ]; then
		cp $STOREDIR/.gitconfig ~
	else
		echo "$STOREDIR does not exist!"
	fi
}

install_git () {
	echo ${FUNCNAME[0]}
	$aptins git git-email
	loadconf_git
}

chromeimg="google-chrome-stable_current_amd64.deb"
chromeprofile="OmegaProfile*.pac"

store_google-chrome () {
	echo ${FUNCNAME[0]}
	mkdir -p $STOREDIR
	find ~ -path $STOREDIR -prune -o -name $chromeimg \
		-exec mv -t $STOREDIR {} \;
	if [ ! -f $STOREDIR/$chromeimg ]; then
		echo "$STOREDIR/$chromeimg does not exist!"
	fi
	find ~ -path $STOREDIR -prune -o -name $chromeprofile \
		-exec mv -t $STOREDIR {} \;
}

install_google-chrome () {
	echo ${FUNCNAME[0]}
	if [ -d $STOREDIR ]; then
		sudo dpkg -i $STOREDIR/google-chrome-stable_current_amd64.deb
		$aptins -f
	else
		echo "$STOREDIR does not exist!"
	fi
}

earthimg="google-earth-stable_current_amd64.deb"
lsbcore="lsb-core_4.1+Debian13+nmu1_amd64.deb"
lsbsecurity="lsb-security_4.1+Debian13+nmu1_amd64.deb"
lsbinvalidmta="lsb-invalid-mta_4.1+Debian13+nmu1_all.deb"
lsbpkgs="lsb-*"
lsblist="$lsbcore $lsbsecurity $lsbinvalidmta"

store_google-earth () {
	echo ${FUNCNAME[0]}
	mkdir -p $STOREDIR
	# lsb packages
	find ~ -path $STOREDIR -prune -o -name $lsbpkgs \
		-exec mv -t $STOREDIR {} +
	for f in $lsblist; do
		if [ ! -f $STOREDIR/$f ]; then
			echo "$STOREDIR/$f does not exist!"
		fi
	done
	# earth
	find ~ -path $STOREDIR -prune -o -name $earthimg \
		-exec mv -t $STOREDIR {} \;
	if [ ! -f $STOREDIR/$earthimg ]; then
		echo "$STOREDIR/$earthimg does not exist!"
	fi
}

install_google-earth () {
	echo ${FUNCNAME[0]}
	sudo dpkg -i $STOREDIR/lsb-*.deb
	$aptins
	sudo dpkg -i $STOREDIR/google-earth-stable_current_amd64.deb
	$aptins
}

store_environment () {
	echo ${FUNCNAME[0]}
	storeconf_proxy
	storeconf_bashrc
	store_bin
	store_workdir
	store_android
	storeconf_vim
	storeconf_git
	store_google-chrome
	store_google-earth
}

load_environment () {
	echo ${FUNCNAME[0]}
	$aptupd
	# proxy, bashrc and bin are loaded earlier
#install_proxy
#loadconf_bashrc
#load_bin
	install_ssh
	load_workdir
	load_android
	install_general_tools
	install_vim
	install_git
	install_google-chrome
	install_google-earth
}

cmd_init="$BINDIR/envsync-init.sh"
cmd_store="$BINDIR/envsync-store.sh"
cmd_load="$BINDIR/envsync-load.sh"
echo ""
echo "*******************************************************"
echo "*   Store or load Ubuntu environment.                 *"
echo "*   Usage:                                            *"
echo "*     $cmd_store                   *"
echo "*     $cmd_load                    *"
echo "*   Note: Make sure the network is good before load.  *"
echo "*******************************************************"
echo ""
echo $0
if [ $0 = $cmd_store ]; then
	echo "store"
	store_environment
	cp $cmd_init $STOREDIR
elif [ $0 = $cmd_load ]; then
	echo "load"
	load_environment
else
	echo "Invalid input: $0"
fi
echo "Done"
