#!/bin/bash

# ko.sh
# One of two scripts for Linux kernel modules build and deploy.
# On develop pc: ~/bin/mmm.sh: generate .ko modules and the list of modules,
#                and then move the modules and the list to $target_dir.
# On target machine: $target_dir/ko.sh: apply the .ko modules according to the
#                    list, and then remove the list.
# Copyright (c) Han Lu <tridlh@gmail.com>

listfile="ko.list"
prefix=/lib/modules/$(uname -r)/kernel
echo "updating .ko module..."
cat $listfile
while read line
do
	src=$(basename $line)
	dst=$prefix/$(dirname $line)/
	echo "move" $src "to" $dst "..."
	sudo mv $src $dst -f
done < $listfile
sync
echo "removing list"
rm -f $listfile
echo "done! rebooting..."
sudo reboot
