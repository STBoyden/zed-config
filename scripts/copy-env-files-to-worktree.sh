#!/usr/bin/env bash
set -euo pipefail

src=${ZED_MAIN_GIT_WORKTREE:?}
dst=${ZED_WORKTREE_ROOT:?}

if [ "$src" = "$dst" ]; then
  echo "Already in the main worktree; nothing to copy."
  exit 0
fi

cd "$src"

find . \
  -type f \
  \( -name ".env" -o -name ".env.*" \) \
  -not -path "*/.git/*" \
  -not -path "*/node_modules/*" \
  -print0 |
  while IFS= read -r -d "" file; do
    rel=${file#./}
    mkdir -p "$dst/$(dirname "$rel")"
    cp -p "$src/$rel" "$dst/$rel"
    echo "Copied $rel"
  done
