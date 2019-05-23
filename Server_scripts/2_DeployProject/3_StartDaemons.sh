#!/bin/bash

DirBackup="$PWD"
ProjectRootDir="/var/lib/boinc_projects/MyBoincProject"

cd "$ProjectRootDir"
# Change "PASSWORD" to user password
echo "PASSWORD" | sudo -S ./bin/start
cd "$DirBackup"

