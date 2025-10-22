#!/usr/bin/env bash

./scripts/check-remote.sh
code=$?

tag="[UPDATE REMOTE]"

case $code in
	1)
        echo "$tag We're behind - Updating from remote"

        git pull --ff-only 1>/dev/null \
            || (
                echo "$tag Could not update from remote (exit code ${?}). Please resolve manually." \
                && exit 1
            )
		;;

	127)
	    echo "$tag Could not check remote - exiting..."
		exit 127
		;;

	*)
	    ;;
esac

git add .
git commit -m "update: state of config at $(date "+%Y-%m-%d %H:%M:%S")"
git push

read -p "Press Enter to exit" </dev/tty
