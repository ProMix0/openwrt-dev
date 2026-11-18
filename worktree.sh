#!/bin/sh

set -e

WORKTREE_PATH=worktrees
OPENWRT_BARE_GIT=openwrt/

if [[ -z "$1" ]]; then
	echo "No worktree name provided!"
	exit 1;
fi

if [[ "$1" != "$(basename "$1")" ]]; then
	echo "'$1' isn't a simple name!"
	exit 1;
fi

if [[ ! -e "$WORKTREE_PATH/$1" ]]; then
	git --git-dir "$OPENWRT_BARE_GIT" worktree add "$WORKTREE_PATH/$1"
fi

# TODO force OpenWRT config (reproducible, dl dir, etc)

