#!/usr/bin/env nu

let tag = "[GIT CHECK REMOTE]"
let new_origin = "ssh://git@codeberg.org/STBoyden/zed-config.git"

let current_remote_result = (git remote get-url origin | complete)
let current_remote = if $current_remote_result.exit_code == 0 {
  $current_remote_result.stdout | str trim
} else {
  ""
}

if $current_remote != $new_origin {
  print $"($tag) Remote is not set to Codeberg - migrating..."

  let set_url = (git remote set-url origin $new_origin | complete)
  if $set_url.exit_code != 0 {
    let add_origin = (git remote add origin $new_origin | complete)
    if $add_origin.exit_code != 0 {
      print --stderr ($add_origin.stderr | str trim)
      exit $add_origin.exit_code
    }
  }

  let pull = (git pull origin main | complete)
  if $pull.exit_code != 0 {
    print --stderr ($pull.stderr | str trim)
    exit 1
  }
} else {
  print $"($tag) Remote is already set to Codeberg - skipping migration."
}

let remote_update = (git remote update | complete)
if $remote_update.exit_code != 0 {
  print --stderr ($remote_update.stderr | str trim)
}

let status = (git -P status -uno | lines | get 1? | default "")

if ($status | str contains "up to date") {
  print $"($tag) All up to date."
  exit 0
} else if ($status | str contains "behind") {
  print $"($tag) We're behind remote."
  exit 1
} else if ($status | str contains "ahead") {
  print $"($tag) We're ahead of the remote."
  exit 2
} else {
  print $"($tag) Unknown status: ($status)"
  exit 127
}
