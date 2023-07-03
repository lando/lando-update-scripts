#!/usr/bin/env bash

cat ../plugins-update/plugin-names.txt | while read line 
do 
  yarn add @lando/$line@0.7.0
done
