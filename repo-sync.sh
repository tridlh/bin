#!/bin/bash

# repo-sync.sh
# store snapshot of a Linux project on ~/git/<project name>/,
# and if necessary, build and store image to ~/git/img/.
# Copyright (c) Han Lu <tridlh@gmail.com>

GITDIR=~/git
IMGDIR=${GITDIR}/img

drm=drm-intel
drm_bxt=drm-intel-bxt
tiwai=tiwai

now=`date +%F_%H%M_%V.%u`

usage () {
	echo ""
	echo "Usage:"
	echo "  $0 <project> <build?>"
	echo "  <project>: projects on ${GITDIR}"
	echo "  <build?>: 1 to sync and build; 0 to sync only"
	echo ""
}

init_prj () {
	branch_remote=$1
	branch_now=${2}-${now}
	branch_now_error=${branch_now}-error
}

#
# main function
#

# get parameter
if [ $# -ne 2 ]; then
	echo "Invalid input! exit"
	usage
	exit
else
	prj=$1
	PRJDIR=${GITDIR}/${prj}
	if [ ! -d ${PRJDIR} ]; then
		echo "${PRJDIR} does not exist!"
		exit 1
	fi
	build=$2
	if [ ${build} -eq 1 ]; then
		PRJIMGDIR=${IMGDIR}/${prj}/${now}
		mkdir -p ${PRJIMGDIR}
	fi
fi

if [ ${prj} == ${drm} ]; then
	init_prj "origin/drm-intel-nightly" "din"
elif [ ${prj} == ${drm_bxt} ]; then
	init_prj "origin/drm-intel-nightly" "din"
elif [ ${prj} == ${tiwai} ]; then
	init_prj "origin/for-next" "fn"
else
	init_prj "origin/master" "master"
fi

# sync
echo "Syncing..."
cd ${PRJDIR}
git reset --hard
git fetch
if [ $? -eq 0 ]; then
	git checkout ${branch_remote} -b ${branch_now}
	echo "Sync ${prj}: ${now} succeed."
else
	git checkout ${branch_remote} -b ${branch_now_error}
	echo "Sync ${prj}: ${now} fail."
	exit
fi

# build
if [ ${build} -eq 1 ]; then
	make oldconfig
	make -j 8 deb-pkg
	cd ..
	mv *.deb ${PRJIMGDIR}
	rm linux-*
fi

echo "Sync ${prj}: ${now} done."
