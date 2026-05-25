#!/usr/bin/env nu

let src = $env.ZED_MAIN_GIT_WORKTREE
let dst = $env.ZED_WORKTREE_ROOT

if $src == $dst {
  print "Already in the main worktree; nothing to copy."
  exit 0
}

for file in (glob --no-dir ($src | path join "**/.env*")) {
  let rel = ($file | path relative-to $src)

  if ($rel | str starts-with ".git/") or ($rel | str contains "/.git/") or ($rel | str starts-with "node_modules/") or ($rel | str contains "/node_modules/") {
    continue
  }

  let dest = ($dst | path join $rel)
  mkdir ($dest | path dirname)
  cp -p $file $dest
  print $"Copied ($rel)"
}
