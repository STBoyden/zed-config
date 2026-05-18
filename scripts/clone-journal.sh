#!/usr/bin/env bash

tag="[CLONE OR UPDATE JOURNAL]"

if [ ! -d "$HOME/journal" ]; then
	echo "$tag Cloning journal..."
	git clone ssh://git@codeberg.org/STBoyden/zed-journal ~/journal
	echo "$tag Journal cloned."
else
	echo "$tag Journal already exists."
	echo "$tag Pulling latest changes..."
	(
		cd ~/journal
		git pull >/dev/null
	)
	result=$?

	if [ $result -ne 0 ]; then
		echo "$tag Failed to pull latest changes -- is the directory a git repository?"
	fi

	echo "$tag Latest changes pulled."
fi
