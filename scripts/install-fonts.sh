#/usr/bin/env bash

set -xeuo pipefail

function darwin() {
	if ! command -v brew &>/dev/null; then
		echo "brew is not installed: install from https://brew.sh/"
		exit 1
	fi

	brew install --cask font-monaspace-nf font-fira-code-nerd-font
	echo "Monaspace & Fira Code Nerd Fonts installed"
}

function linux() {
	if ! command -v git &>/dev/null; then
		echo "git is not installed"
		exit 1
	fi

	if ! command -v unzip &>/dev/null; then
		echo "unzip is not installed"
		exit 1
	fi

	mkdir ./tmp

	echo "Creating ~/.local/share/fonts if it doesn't already exist"
	mkdir -p ~/.local/share/fonts

	echo "Downloading Fira Code Nerd Font"
	curl -L -o ~/.local/share/fonts/FiraCode.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip
	(cd ~/.local/share/fonts && unzip FiraCode.zip && rm FiraCode.zip)

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
