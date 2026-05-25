#!/usr/bin/env nu

$env.NU_LOG_LEVEL = "debug"

def command-exists [name: string] {
  not (which $name | is-empty)
}

def darwin [] {
  if not (command-exists brew) {
    print --stderr "brew is not installed: install from https://brew.sh/"
    exit 1
  }

  brew install --cask font-monaspace-nf font-fira-code-nerd-font
  print "Monaspace & Fira Code Nerd Fonts installed"
}

def linux [] {
  if not (command-exists git) {
    print --stderr "git is not installed"
    exit 1
  }

  if not (command-exists unzip) {
    print --stderr "unzip is not installed"
    exit 1
  }

  let tmp_dir = "./tmp"
  mkdir $tmp_dir

  let fonts_dir = ($nu.home-path | path join ".local/share/fonts")
  print $"Creating ($fonts_dir) if it doesn't already exist"
  mkdir $fonts_dir

  print "Downloading Fira Code Nerd Font"
  curl -L -o ($fonts_dir | path join "FiraCode.zip") https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip
  unzip ($fonts_dir | path join "FiraCode.zip") -d $fonts_dir
  rm ($fonts_dir | path join "FiraCode.zip")

  print "Cloning Monaspace from GitHub"
  git clone git@github.com:githubnext/monaspace ($tmp_dir | path join "monaspace")

  for font in (glob ($tmp_dir | path join "monaspace/fonts/NerdFonts/*")) {
    print $"Installing ($font)"
    cp -r $font $fonts_dir
  }

  fc-cache -f
  rm -rf $tmp_dir
}

match $nu.os-info.name {
  "macos" => { darwin },
  "linux" => { linux },
  _ => { print --stderr $"Unsupported OS: ($nu.os-info.name)"; exit 1 },
}
