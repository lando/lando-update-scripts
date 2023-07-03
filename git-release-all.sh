#!/usr/bin/env bash

for dir in */; do
  cd $dir
  git checkout main
  git pull
  old_version="v$(cat package.json | jq -r '.version')"
  version=$(awk -F. -v minor=1 -v patch=0 '{print $1, $2+minor, patch}' <<< "$old_version" | tr ' ' '.')
  git push --tags
  gh release create $version --title "${version}" --notes "  * Removed bundle-dependencies and version-bump-prompt from plugin.
  * Updated package to use prepare-release-action.
  * Updated documentation to reflect new release process."
  sleep 10
  cd ..
done