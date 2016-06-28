#!/bin/bash
# gitformatpatch
# Generate a patch
base="origin/master"
if [ $# -eq 1 ]; then
	base=$1
fi
git format-patch -s -n -p --subject="PATCH RFC" ${base} --cover --thread=shallow
#git format-patch -s -n -p --subject="PATCH V4" ${base} --cover --thread=shallow
#git format-patch -s -n -p --subject="PATCH" ${base}
