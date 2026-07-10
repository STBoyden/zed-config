#!/usr/bin/env nu

def main [] {
    const config_dir = path self ..
    let source = ($config_dir | path join ".black-metal-theme")
    let repository = "git@codeberg.org:STBoyden/zed-black-metal-themes.git"

    print "Installing the Zed extension CLI..."
    let cargo_args = [
        "install"
        "--git"
        "https://github.com/zed-industries/zed.git"
        "--locked"
        "extension_cli"
    ]
    ^cargo ...$cargo_args

    if ($source | path exists) {
        print $"Updating the Black Metal theme in ($source)..."
        ^git -C $source pull --ff-only
    } else {
        print $"Cloning the Black Metal theme into ($source)..."
        ^git clone $repository $source
    }

    let manifest = ($source | path join "extension.toml")
    if not ($manifest | path exists) {
        error make {
            msg: $"No extension.toml found in ($source)"
        }
    }

    let extension_id = (open $manifest | get id)
    let cache_root = ($env.XDG_CACHE_HOME? | default ($env.HOME | path join ".cache"))

    let data_root = match $nu.os-info.name {
        "macos" => {
            $env.HOME | path join "Library" "Application Support" "Zed"
        }
        "linux" => {
            let data_home = (
                $env.XDG_DATA_HOME?
                | default ($env.HOME | path join ".local" "share")
            )

            $data_home | path join "zed"
        }
        $os => {
            error make {
                msg: $"Unsupported operating system: ($os)"
            }
        }
    }

    let working_dir = ($cache_root | path join "zed-extension-cli" $extension_id)
    let output_dir = ($working_dir | path join "output")
    let scratch_dir = ($working_dir | path join "scratch")
    let install_dir = (
        $data_root
        | path join "extensions" "installed" $extension_id
    )

    rm --recursive --force $working_dir
    mkdir $output_dir $scratch_dir

    print $"Packaging ($extension_id)..."
    let package_args = [
        "--source-dir"
        $source
        "--output-dir"
        $output_dir
        "--scratch-dir"
        $scratch_dir
    ]
    ^zed-extension ...$package_args

    print $"Installing into ($install_dir)..."
    rm --recursive --force $install_dir
    mkdir $install_dir

    ^tar -xzf ($output_dir | path join "archive.tar.gz") -C $install_dir

    rm --recursive --force $working_dir

    print $"Installed ($extension_id). Restart Zed to load it."
}
