#!/bin/bash
# gitcleanfile
# Clean file
file="*.c *.h"
if [ $# -eq 1 ]; then
	file=$1
fi
/lib/modules/`uname -r`/build/scripts/cleanfile $file
