#!/usr/bin/env bash

cat plugin-names.txt | while read line 
do 
  cd $line
  git add .
  git commit -m "chore: update release process"
  git push
  cd ..
done
