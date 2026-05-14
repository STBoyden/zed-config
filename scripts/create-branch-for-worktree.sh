#!/usr/bin/env bash
set -euo pipefail

src=${ZED_MAIN_GIT_WORKTREE:?}
dst=${ZED_WORKTREE_ROOT:?}
dry_run=${DRY_RUN:-}

if [ "$src" = "$dst" ]; then
	echo "Already in the main worktree; no branch to create."
	exit 0
fi

current_branch=$(git -C "$dst" symbolic-ref --quiet --short HEAD || true)
main_branch=$(git -C "$src" symbolic-ref --quiet --short HEAD || true)

if [ -n "$current_branch" ] && [ "$current_branch" != "$main_branch" ]; then
	echo "Already on branch $current_branch."
	exit 0
fi

worktree_name=$(basename "$dst")
repo_name=$(basename "$src")

if [ "$worktree_name" = "$repo_name" ]; then
	worktree_name=$(basename "$(dirname "$dst")")
fi

branch_base=$(
	printf "%s" "$worktree_name" |
		tr "[:upper:]" "[:lower:]" |
		sed -E "s/[^a-z0-9._-]+/-/g; s/^-+//; s/-+$//; s/-+/-/g"
)

if [ -z "$branch_base" ]; then
	branch_base="worktree"
fi

branch_name="$branch_base"
suffix=2

while ! git -C "$dst" check-ref-format --branch "$branch_name" >/dev/null 2>&1 ||
	git -C "$dst" show-ref --verify --quiet "refs/heads/$branch_name"; do
	if [ "$current_branch" = "$branch_name" ]; then
		echo "Already on branch $branch_name."
		exit 0
	fi

	branch_name="${branch_base}-${suffix}"
	suffix=$((suffix + 1))
done

if [ -n "$dry_run" ]; then
	echo "Would create branch $branch_name."
	exit 0
fi

git -C "$dst" switch -c "$branch_name"
echo "Created branch $branch_name."
