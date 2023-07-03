#!/usr/bin/env bash

for dir in */; do
  cd $dir
  plugin=$(echo $dir | rev | cut -c2- | rev)
  version=$(cat package.json | jq -r '.version')

  # Checkout new branch
  git checkout -b release-action

  # Remove unnecessary packages
  yarn remove bundle-dependencies version-bump-prompt
  
  # Remove the release script
  # Add prepare-release-action to release.yml
  # Update Documentation
  php ../str_replace.php $dir

  # Modify changelog
  new_version=$(awk -F. -v minor=1 -v patch=0 '{print $1, $2+minor, patch}' <<< "$version" | tr ' ' '.')
  echo "## v${new_version} - [July 3, 2023](https://github.com/lando/$plugin/releases/tag/v${new_version})
  * Removed bundle-dependencies and version-bump-prompt from plugin.
  * Updated package to use prepare-release-action.
  * Updated documentation to reflect new release process.
" > changelog-update.md
  cat CHANGELOG.md >> changelog-update.md
  mv changelog-update.md CHANGELOG.md

  rm *.bak
  rm .github/workflows/*.bak

  git add .
  git commit -m "chore: update release process"
  git push
  gh pr create --fill
  sleep 10
  cd ..
done