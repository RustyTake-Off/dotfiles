#!/usr/bin/env bash
# Move directories and files to a different branch

# GitHub        - https://github.com/RustyTake-Off
# GitHub Repo   - https://github.com/RustyTake-Off/dotfiles
# Author        - RustyTake-Off
# Version       - 0.1.2

set -e

# Variables passed as inputs
declare SOURCE_BRANCH_NAME="$1"
declare TARGET_BRANCH_NAME="$2"
declare OTHER_DIRS_FILES="$3"
declare USER_NAME="$4"
declare USER_EMAIL="$5"

# Switch to the target branch
git checkout -b "$TARGET_BRANCH_NAME" --track "origin/$TARGET_BRANCH_NAME" > /dev/null

# Remove all files and reset
git rm -rf . > /dev/null
git reset > /dev/null

# Checkout necessary files and directories
git checkout "$SOURCE_BRANCH_NAME" -- "$TARGET_BRANCH_NAME" > /dev/null
[ -n "$OTHER_DIRS_FILES" ] \
&& git checkout "$SOURCE_BRANCH_NAME" -- "$OTHER_DIRS_FILES" > /dev/null

# Copy files and directories
cp -r "$TARGET_BRANCH_NAME"/* .
find "$TARGET_BRANCH_NAME" -maxdepth 1 -name '.*[!.]*' -exec cp -r {} . \;

if [ -n "$OTHER_DIRS_FILES" ]; then
  shopt -s dotglob

  for item in $OTHER_DIRS_FILES; do
    if [ -f "$item" ] && [ -s "$item" ]; then
      cp "$item" .
    elif [ -d "$item" ]; then
      cp -r "$item" .
    fi
  done

  shopt -u dotglob
fi

# Clean up
rm -rf "$TARGET_BRANCH_NAME"
rm README.md to_move.yaml

if [ -n "$OTHER_SHARED_FILES" ]; then

  for item in $OTHER_SHARED_FILES; do
    dir=$(dirname "$item")
    [ -d "$dir" ] && rm -rf "$dir"
  done

fi

# Commit and push
git config --global user.name "$USER_NAME"
git config --global user.email "$USER_EMAIL"

git add --all

echo ''
echo '===  Status  ==========================='
echo ''
git status --short

echo ''
echo '===  Commit  ==========================='
echo ''
git commit -m "Update $TARGET_BRANCH_NAME | $(date '+%d/%m/%Y') - $(date '+%H:%M:%S')"

echo ''
echo '===  Push    ==========================='
echo ''
git push origin "$TARGET_BRANCH_NAME"
