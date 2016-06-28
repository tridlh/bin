#!/bin/bash
# gitcheckpatch
# Check a patch before submitting.
patch="*.patch"
if [ $# -eq 1 ]; then
	patch=$1
fi
/lib/modules/`uname -r`/build/scripts/checkpatch.pl --no-tree $patch
