#!/usr/bin/env bash
for dir in */; do
  plugin=$(echo $dir | rev | cut -c2- | rev)
  echo $plugin >> plugin-names.txt
done