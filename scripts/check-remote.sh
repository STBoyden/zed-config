#!/usr/bin/env bash

git remote update 2>&1 >/dev/null

status=$(git -P status -uno | head -n2 | tail -n1)
tag="[GIT CHECK REMOTE]"

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
		exit 127
		;;
esac
