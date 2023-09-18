#!/bin/bash

# Remove the # if you only want to rebuild if there are new commits
git pull # | grep "Already up to date" && exit

DATE=$(date +"%Y-%m-%d")

BRANCH_NAME=$(git branch --no-color | grep \* | cut -d' ' -f2)

BUILD_DIR="$BRANCH_NAME-$DATE"

./scripts/feeds update -a
./scripts/feeds install -a

JOB_COUNT=$(cat /proc/cpuinfo | grep processor | wc -l)

cp -f config.mesh.all .config

make -j$JOB_COUNT IGNORE_ERRORS=m CONFIG_VERSION_REPO_CORE="$PACKAGE_REPO_CORE_BASE/$BUILD_DIR"

mkdir -p "$TARGET_DIR/$BUILD_DIR"
cp -r bin/targets "$TARGET_DIR/$BUILD_DIR/"
chgrp -R www-data "$TARGET_DIR/$BUILD_DIR/"
