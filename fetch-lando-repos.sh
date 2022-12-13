#!/usr/bin/env bash

gh repo list lando -L 100 --json sshUrl,description --jq '.[]|select(.description | startswith("The Official"))' | grep -Eo "git@github\.com:lando.*git" | sort -u > repo-names.txt

cat repo-names.txt | while read line 
do 
  git clone ${line}
done

for dir in */; do
  cd $dir
  plugin=$(echo $dir | rev | cut -c2- | rev)
  # Checkout new branch
  git checkout -b 0.7-update
  # Update with bundle-dependencies
  yarn add --dev bundle-dependencies
  # Add bundle-dependencies to release
  sed -i .bak 's/"release": "/"release": "bundle-dependencies update \&\& /g' package.json
  # Replace Erroneous pr-workflow strings.
  sed -i .bak "s/apache/$plugin/g" .github/workflows/pr-$plugin-tests.yml
  sed -i .bak "s/acquia/$plugin/g" .github/workflows/pr-$plugin-tests.yml
  # Correct dogfooding expression
  sed -i .bak 's/echo \"::error:: Not dogfooding this plugin correctly! \"/(echo \"::error:: Not dogfooding this plugin correctly!\" \&\& exit 1)/g' .github/workflows/pr-$plugin-tests.yml
  # sed -i .bak 's/lando config --path plugins | grep apache | grep \/home\/runner\/work\/apache\/apache || echo "::error:: Not dogfooding this plugin correctly! "/lando config --path plugins | grep ${dir} | grep \/home\/runner\/work\/${dir}\/${dir} || (echo "::error:: Not dogfooding this plugin correctly!" && exit 1)/g' .github/workflows/pr-$dir-tests.yml
  # Modify changelog
  echo "## v0.7.0 - [December 12, 2022](https://github.com/lando/$plugin/releases/tag/v0.7.0)
  * Added bundle-dependencies to release process.
  * Fixed bug in plugin dogfooding test.
" > changelog-update.md
  cat CHANGELOG.md >> changelog-update.md
  mv changelog-update.md CHANGELOG.md

  rm *.bak
  rm .github/workflows/*.bak

  # Release bump
  #yarn release

  cd ..
done