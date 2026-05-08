#!/usr/bin/env bash

tag="[GIT CHECK REMOTE]"

current_remote=$(git remote get-url origin)

new_origin="ssh://git@codeberg.org/STBoyden/zed-config.git"
if [ "$current_remote" != "$new_origin" ]; then
    echo "$tag Remote is not set to Codeberg - migrating..."
    git remote set-url origin "$new_origin" || git remote add origin "$new_origin"
    git pull origin main || exit 1
else
    echo "$tag Remote is already set to Codeberg - skipping migration."
fi

git remote update 2>&1 >/dev/null

status=$(git -P status -uno | head -n2 | tail -n1)

case "$status" in
	*"up to date"*)
	    echo "$tag All up to date."
		exit 0
		;;

	*"behind"*)
        echo "$tag We're behind remote."
	    exit 1
		;;

	*"ahead"*)
	    echo "$tag We're ahead of the remote."
	    exit 2
		;;

	*)
	  echo "$tag Unknown status: $status"
		exit 127
		;;
esac
