#/usr/bin/env bash

set -xeuo pipefail

function darwin() {
	if ! command -v brew &>/dev/null; then
		echo "brew is not installed: install from https://brew.sh/"
		exit 1
	fi

	brew install --cask font-monaspace-nf
	echo "Monaspace fonts installed"
}

function linux() {
	if ! command -v git &>/dev/null; then
		echo "git is not installed"
		exit 1
	fi

	mkdir ./tmp

	echo "Creating ~/.local/share/fonts if it doesn't already exist"
	mkdir -p ~/.local/share/fonts

	echo "Cloning Monaspace from GitHub"
	git clone git@github.com:githubnext/monaspace ./tmp/monaspace

	fonts=(./tmp/monaspace/fonts/NerdFonts/*)

	for font in $fonts; do
		echo "Installing ${font}"
		cp -r "${font}" ~/.local/share/fonts/
	done

	fc-cache -f

	rm -rf ./tmp
}

case "${OSTYPE}" in
darwin*)
	darwin
	;;

linux*)
	linux
	;;
esac
