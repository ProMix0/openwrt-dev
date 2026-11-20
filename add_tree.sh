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
	git --git-dir "$OPENWRT_BARE_GIT" worktree add --detach "$WORKTREE_PATH/$1"
fi

do_config() {
local file="$1"
local parameter="$2"
local value="$3"
local sed_script="/^$parameter=/"'{
h
c\
'"$parameter=$value"'
}
'"/ $parameter /"'{
h
c\
'"$parameter=$value"'
}
${
x
/^$/{
a\
'"$parameter=$value"'
H
}
x
}
'

sed -i "$sed_script" "$file"
}

# Set up common settings
[[ ! -e "$WORKTREE_PATH/$1/.config" ]] && echo > "$WORKTREE_PATH/$1/.config"
do_config "$WORKTREE_PATH/$1/.config" 'CONFIG_DEVEL' 'y'
do_config "$WORKTREE_PATH/$1/.config" 'CONFIG_REPRODUCIBLE_DEBUG_INFO' 'y'
do_config "$WORKTREE_PATH/$1/.config" 'CONFIG_DOWNLOAD_FOLDER' "\"$PWD/artifacts/dl\""
do_config "$WORKTREE_PATH/$1/.config" 'CONFIG_CCACHE' 'y'
do_config "$WORKTREE_PATH/$1/.config" 'CONFIG_CCACHE_DIR' "\"$PWD/artifacts/ccache\""

