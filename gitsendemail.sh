#!/bin/bash
# gitsendemail
# Send the patch(es) through email
patch="00*.patch"
tome="--to=tridlh@gmail.com"
toliam="--to=liam.r.girdwood@linux.intel.com"
tolibin="--to=libin.yang@linux.intel.com"
tomengdong="--to=mengdong.lin@linux.intel.com"
tokeyon="--to=yang.jie@linux.intel.com"
totakashi="--to=tiwai@suse.de"
tomark="--to=broonie@kernel.org"
toalsa="--to=alsa-devel@alsa-project.org"
toopengfx="--to=intel-gfx@lists.freedesktop.org"
topulse="--to=pulseaudio-discuss@lists.freedesktop.org"
tolinuxupstream="--to=linux@endlessm.com"
if [ $# -eq 1 ]; then
	patch=$1
fi
git send-email ${totakashi} ${toliam} ${toalsa} ${patch}
