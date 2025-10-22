#!/usr/bin/env bash

git remote update 2>&1 >/dev/null

status=$(git -P status -uno | head -n2 | tail -n1)

case "$status" in
	*"up to date"*)
	    echo "[GIT CHECK REMOTE] All up to date."
		exit 0
		;;

	*"behind"*)
        echo "[GIT CHECK REMOTE] We're behind remote."
	    exit 1
		;;

	*"ahead"*)
	    echo "[GIT CHECK REMOTE] We're ahead of the remote."
	    exit 2
		;;

	*)
		exit 127
		;;
esac
