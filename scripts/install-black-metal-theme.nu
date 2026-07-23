#!/usr/bin/env nu

def main [] {
    const config_dir = path self ..
    let source = ($config_dir | path join ".black-metal-theme")
    let repository = "git@codeberg.org:STBoyden/zed-black-metal-themes.git"

    if ($source | path exists) {
        print $"Updating the Black Metal theme in ($source)..."
        ^git -C $source pull --ff-only
    } else {
        print $"Cloning the Black Metal theme into ($source)..."
        ^git clone $repository $source
    }

    print $"Please install themes + icons as dev extension from ($source)"
}
