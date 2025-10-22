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
                && exit 127
            )
		;;

	127)
	    echo "$tag Could not check remote - exiting..."
		exit 127
		;;

	*)
	    ;;
esac

echo "$tag Updating remote..."

git add .
git commit -m "update: state of config at $(date "+%Y-%m-%d %H:%M:%S")"
git push || (
    echo "$tag Remote could not be updated (exit code ${?}). Please resolve manually." \
    && exit 127
)

echo "$tag ... Updated remote."

read -p "Press Enter to exit" </dev/tty
