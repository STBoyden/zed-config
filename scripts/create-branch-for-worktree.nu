#!/usr/bin/env nu

let src = $env.ZED_MAIN_GIT_WORKTREE
let dst = $env.ZED_WORKTREE_ROOT
let dry_run = ($env.DRY_RUN? | default "")

if $src == $dst {
  print "Already in the main worktree; no branch to create."
  exit 0
}

let current_branch_result = (git -C $dst symbolic-ref --quiet --short HEAD | complete)
let current_branch = if $current_branch_result.exit_code == 0 { $current_branch_result.stdout | str trim } else { "" }

let main_branch_result = (git -C $src symbolic-ref --quiet --short HEAD | complete)
let main_branch = if $main_branch_result.exit_code == 0 { $main_branch_result.stdout | str trim } else { "" }

if ($current_branch | is-not-empty) and $current_branch != $main_branch {
  print $"Already on branch ($current_branch)."
  exit 0
}

mut worktree_name = ($dst | path basename)
let repo_name = ($src | path basename)

if $worktree_name == $repo_name {
  $worktree_name = ($dst | path dirname | path basename)
}

mut branch_base = ($worktree_name
  | str downcase
  | str replace --all --regex "[^a-z0-9._-]+" "-"
  | str replace --regex "^-+" ""
  | str replace --regex "-+$" ""
  | str replace --all --regex "-+" "-"
)

if ($branch_base | is-empty) {
  $branch_base = "worktree"
}

mut branch_name = $branch_base
mut suffix = 2

loop {
  let valid_ref = (git -C $dst check-ref-format --branch $branch_name | complete)
  let ref_exists = (git -C $dst show-ref --verify --quiet $"refs/heads/($branch_name)" | complete)

  if $valid_ref.exit_code == 0 and $ref_exists.exit_code != 0 {
    break
  }

  if $current_branch == $branch_name {
    print $"Already on branch ($branch_name)."
    exit 0
  }

  $branch_name = $"($branch_base)-($suffix)"
  $suffix = $suffix + 1
}

if ($dry_run | is-not-empty) {
  print $"Would create branch ($branch_name)."
  exit 0
}

git -C $dst switch -c $branch_name
print $"Created branch ($branch_name)."
