#!/bin/bash

DirBackup="$PWD"
ProjectRootDir="/var/lib/boinc_projects/MyBoincProject"

cd "$ProjectRootDir"
./bin/xadd
./bin/update_versions
cd "$DirBackup"
