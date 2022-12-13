#!/usr/bin/env bash

cat plugin-names.txt | while read line 
do 
  cd $line
  gh pr create --fill
  sleep 10
  cd ..
done
