#!/usr/bin/env bash

for dir in */; do
  cd $dir
  gh pr merge release-action --admin --squash
  sleep 10
  cd ..
done


