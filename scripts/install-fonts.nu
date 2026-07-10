#!/usr/bin/env nu

$env.NU_LOG_LEVEL = "debug"

def command-exists [name: string] {
  not (which $name | is-empty)
}

def log [tag: string, message: string] {
  print $"[($tag)] ($message)"
}

def install [] {
  if not (command-exists brew) {
    print --stderr "brew is not installed: install from https://brew.sh/"
    exit 1
  }

  brew install --cask font-0xproto-nerd-font
  print "Fonts installed"
}

install
