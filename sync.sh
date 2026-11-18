#!/bin/sh

set -e

OPENWRT_BARE_GIT=openwrt/

awk -F, '! /^#/ {printf "%s %s\n", $1, $2}' remotes.csv | while read name url rest; do
	[[ ! -z "$rest" ]] && exit 1
	[[ -z "$name" ]] && continue
	git --git-dir "$OPENWRT_BARE_GIT" remote | grep -qw "$name" || git --git-dir "$OPENWRT_BARE_GIT" remote add "$name" "$url"
	git --git-dir "$OPENWRT_BARE_GIT" fetch "$name"
done

# 'repo' currently hardcoded
# TODO It doesn't pushes branches from other remotes, isn't it?
git --git-dir "$OPENWRT_BARE_GIT" push --all repo

