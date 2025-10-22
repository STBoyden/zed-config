#!/usr/bin/env bash

./scripts/check-remote.sh
code=$?

tag="[UPDATE LOCAL]"
has_local_changes=false
branch="state-of-config-$(date "+%Y-%m-%d_%H-%M-%S")"

case $code in
	1)
	    git switch -c "$branch"
		git add .
		git commit -m "chore: saving current state"
		git checkout main

		has_local_changes=true

		echo "$tag Saving current state on new branch '$branch'"
		;;

	127)
	    echo "$tag Could not check remote - exiting..."
		exit 127
		;;

	*)
		;;
esac

echo "$tag Updating from remote..."

git pull --ff-only 1>/dev/null \
    || (
        echo "$tag Could not update from remote (exit code ${?}). Please resolve manually." \
        && exit 127
    )

echo "$tag ... Updated successfully."
echo ""

$has_local_changes && \
    echo "$tag Merging local changes from \"$branch\"" \
    && git checkout main \
    && (
        git merge --ff-only 1>/dev/null "$branch" \
        || (
            echo "$tag Could not merge local changes from $branch. Please try resolving manually." \
            && exit 127
        )
    )

read -p "Press Enter to exit" </dev/tty
