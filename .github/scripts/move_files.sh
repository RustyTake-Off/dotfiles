#!/usr/bin/env bash
# Move directories and files to a different branch

# GitHub        - https://github.com/RustyTake-Off
# GitHub Repo   - https://github.com/RustyTake-Off/dotfiles
# Author        - RustyTake-Off

set -e

# Variables passed as inputs
source_branch_name="$1"
target_branch_name="$2"
other_dirs_files="$3"
user_name="$4"
user_email="$5"

# Stash changes in the .github directory to fix error, after changing move_files.sh script permissions
git stash push -m "Stash .github changes" -- .github

# Switch to the target branch
git checkout -b "$target_branch_name" --track "origin/$target_branch_name" > /dev/null

# Remove all files and reset
git rm -rf . > /dev/null
git reset > /dev/null

# Checkout necessary files and directories
git checkout "$source_branch_name" -- $target_branch_name > /dev/null
[[ -n "$other_dirs_files" ]] \
&& git checkout "$source_branch_name" -- $other_dirs_files > /dev/null

# Copy files and directories
cp -r "$target_branch_name"/* .
find "$target_branch_name" -maxdepth 1 -name '.*[!.]*' -exec cp -r {} . \;

if [[ -n "$other_dirs_files" ]]; then
  shopt -s dotglob

  for item in $other_dirs_files; do
    if [[ -f "$item" ]] && [[ -s "$item" ]]; then
      cp "$item" .
    elif [[ -d "$item" ]]; then
      cp -r "$item" .
    fi
  done

  shopt -u dotglob
fi

# Clean up
rm -rf "$target_branch_name"
rm README.md to_move.yaml

if [[ -n "$other_dirs_files" ]]; then

  for item in $other_dirs_files; do
    dir="${item%/*}"
    [[ -d "$dir" ]] && rm -rf "$dir"
  done

fi

# Commit and push
git config --global user.name "$user_name"
git config --global user.email "$user_email"

git add --all

if [[ -z "$(git diff --staged)" ]]; then
  echo ''
  echo '===  No changes to commit   ============'
  echo ''
  exit 0
fi

echo ''
echo '===  Status  ==========================='
echo ''
git status --short

echo ''
echo '===  Commit  ==========================='
echo ''
git commit -m "Update $target_branch_name | $(date '+%d/%m/%Y') - $(date '+%H:%M:%S')"

echo ''
echo '===  Push    ==========================='
echo ''
git push origin "$target_branch_name"
