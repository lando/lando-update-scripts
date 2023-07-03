#!/usr/bin/env bash

gh repo list lando -L 100 --json sshUrl,description --jq '.[]|select(.description | startswith("The Official"))' | grep -Eo "git@github\.com:lando.*git" | sort -u > repo-names.txt

cat repo-names.txt | while read line 
do 
  git clone ${line}
done