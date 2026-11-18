#!/bin/sh

set -e

OPENWRT_BARE_GIT=openwrt/

if [[ ! -e "$OPENWRT_BARE_GIT" ]]; then
	git clone --bare https://github.com/openwrt/openwrt.git "$OPENWRT_BARE_GIT"
fi

