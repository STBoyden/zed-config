#!/usr/bin/env nu

let tag = "[CLONE OR UPDATE JOURNAL]"
let journal_dir = ($nu.home-path | path join "journal")

if not ($journal_dir | path exists) {
  print $"($tag) Cloning journal..."
  git clone ssh://git@codeberg.org/STBoyden/zed-journal $journal_dir
  print $"($tag) Journal cloned."
} else {
  print $"($tag) Journal already exists."
  print $"($tag) Pulling latest changes..."

  let result = (git -C $journal_dir pull | complete)

  if $result.exit_code != 0 {
    print $"($tag) Failed to pull latest changes -- is the directory a git repository?"
    exit $result.exit_code
  }

  print $"($tag) Latest changes pulled."
}
