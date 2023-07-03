#!/usr/bin/env bash

./fetch-lando-repos.sh
./update-lando-repos.sh
./git-release-all.sh