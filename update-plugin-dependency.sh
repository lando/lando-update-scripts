#!/usr/bin/env bash

for dir in */; do
  cd $dir
  plugin=$(echo $dir | rev | cut -c2- | rev)

  # Make sure we're up to date
  git checkout main
  git reset --hard
  git pull
  npm install

  # If package.json uses lando/mysql, update to latest version
  if grep -q "lando/mysql" package.json; then
    # Find latest version of lando/mysql
    mysql_version=$(curl -s https://api.github.com/repos/lando/mysql/releases/latest | jq -r '.tag_name')
    echo "Updating $plugin to use lando/mysql@$mysql_version"
    npm install @lando/mysql@$mysql_version
  fi

  git diff --exit-code
  if [ $? -eq 0 ]; then
    echo "No changes made to $plugin"
    cd ..
    mv $dir processed
    continue
  fi

  # Modify changelog
  php ../changelog_update.php $plugin $mysql_version

  # Checkout new branch
  git checkout -b update-mysql-$mysql_version

  git add .
  git commit -m "Update setup-lando to v3, ubuntu-24.04, and 3-edge-slim. Introduce new .lando.yml template for docs.";
  # git push
  # gh pr create --fill
  sleep 2
  cd ..
  mv $dir processed
done