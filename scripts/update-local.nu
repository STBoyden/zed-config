#!/usr/bin/env nu

let tag = "[UPDATE LOCAL]"
mut has_local_changes = false
let branch = $"state-of-config-(date now | format date '%Y-%m-%d_%H-%M-%S')"

let check = (nu ./scripts/check-remote.nu | complete)
if ($check.stdout | str trim | is-not-empty) { print ($check.stdout | str trim) }
if ($check.stderr | str trim | is-not-empty) { print --stderr ($check.stderr | str trim) }
let code = $check.exit_code

match $code {
  1 => {
    git switch -c $branch
    git add .
    git commit -m "chore: saving current state"
    git checkout main

    $has_local_changes = true

    print $"($tag) Saving current state on new branch '($branch)'"
  },
  127 => {
    print $"($tag) Could not check remote - exiting..."
    exit 127
  },
  _ => {}
}

print $"($tag) Updating from remote..."

let pull = (git pull --ff-only | complete)
if $pull.exit_code != 0 {
  let pull_code = $pull.exit_code
  print ([$tag " Could not update from remote (exit code " $pull_code "). Please resolve manually."] | str join)
  exit 127
}

print $"($tag) ... Updated successfully."
print ""

if $has_local_changes {
  print $"($tag) Merging local changes from \"($branch)\""
  git checkout main

  let merge = (git merge --ff-only $branch | complete)
  if $merge.exit_code != 0 {
    print $"($tag) Could not merge local changes from ($branch). Please try resolving manually."
    exit 127
  }
}

input "Press Enter to exit"
