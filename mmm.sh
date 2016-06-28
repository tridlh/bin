#!/bin/bash

# mmm.sh
# One of two scripts for Linux kernel modules build and deploy.
# On develop pc: ~/bin/mmm.sh: generate .ko modules and the list of modules,
#                and then move the modules and the list to $target_dir.
# On target machine: $target_dir/ko.sh: apply the .ko modules according to the
#                    list, and then remove the list.
# Copyright (c) Han Lu <tridlh@gmail.com>

target_dir="~/work/`whoami`-work"
echo "make linux kernel..."
make -j 8 | grep '\.ko' | awk '$1=="LD"{print $3}' >> ko.list
echo "new generated .ko modules:"
grep '\.ko' ko.list
echo "copying .ko modules..."
grep '\.ko' ko.list | xargs -I {} cp {} ${target_dir}
echo "moving list..."
mv ko.list ${target_dir}
