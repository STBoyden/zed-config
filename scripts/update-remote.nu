#!/usr/bin/env nu

let tag = "[UPDATE REMOTE]"

let check = (nu ./scripts/check-remote.nu | complete)
if ($check.stdout | str trim | is-not-empty) { print ($check.stdout | str trim) }
if ($check.stderr | str trim | is-not-empty) { print --stderr ($check.stderr | str trim) }
let code = $check.exit_code

match $code {
  1 => {
    print $"($tag) We're behind - Updating from remote"

    let pull = (git pull --ff-only | complete)
    if $pull.exit_code != 0 {
          let pull_code = $pull.exit_code
          print ([$tag " Could not update from remote (exit code " $pull_code "). Please resolve manually."] | str join)
          exit 127
        }
  },
  127 => {
    print $"($tag) Could not check remote - exiting..."
    exit 127
  },
  _ => {}
}

print $"($tag) Updating remote..."

git add .
let state_message = $"update: state of config at (date now | format date '%Y-%m-%d %H:%M:%S')"
let hostname_message = $"Updates from device with hostname: (sys host | get hostname)"
git commit -m $state_message -m $hostname_message

let push = (git push | complete)
if $push.exit_code != 0 {
  let push_code = $push.exit_code
  print ([$tag " Remote could not be updated (exit code " $push_code "). Please resolve manually."] | str join)
  exit 127
}

print $"($tag) ... Updated remote."

input "Press Enter to exit"
