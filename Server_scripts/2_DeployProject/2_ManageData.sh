#!/bin/bash

DirBackup="$PWD"
datetime=$(date '+%Y-%m-%d_%H:%M:%S');

# ---------------------------------------------- Variables


ApplicationName_1="ProthPrimeSearch_application"
ApplicationFolderName_1="ProthPrimeSearchData"


LocalRootDir="/home/boincadm/Desktop/BOINC_data/2_DeployProject"
BoincSrcRootDir="/home/boincadm/boinc"
ProjectRootDir="/var/lib/boinc_projects/MyBoincProject"
OutputBackupDir="/home/boincadm/Desktop/Deploy.bak"

FileSignExtension=".sig"

PrivateKeyFile="$ProjectRootDir""/keys/code_sign_private"
SignToolFile="$BoincSrcRootDir""/tools/sign_executable"


InputDataDir="$LocalRootDir"/"InputData"
OutputDataDir="$LocalRootDir"/"DeployData"


ApplicationDir="$InputDataDir"/"Application"
WorkGeneratorDir="$InputDataDir"/"WorkGenerator"
ResultsValidatorDir="$InputDataDir"/"ResultsValidator"
AsimilatorDir="$InputDataDir"/"Asimilator"


JobExecExtension=".e"
WorkGeneratorDir_Out="$OutputDataDir"/"bin"
ResultsValidatorDir_Out="$OutputDataDir"/"bin"
AsimilatorDir_Out="$OutputDataDir"/"bin"


# ---------------------------------------------- Cleanup

if [ ! -z "$OutputDataDir" ]; then
	rm -rf "$OutputDataDir"/*
fi

# ---------------------------------------------- Sign the Application


for FileToSign in "$ApplicationDir"/*; do
    [[ "$FileToSign" == *"$FileSignExtension" ]] && continue
    "$SignToolFile" "$FileToSign" "$PrivateKeyFile" > "$FileToSign""$FileSignExtension"
done


# ---------------------------------------------- Copy application

# -------- Get last active version

LastVersionString="$(ls -v "$ProjectRootDir"/apps/"$ApplicationName_1"/  | tail -n 1)"

if [ -z "${LastVersionString}" ]; then
	LastVersionString=1.0
fi


IFS='.' read MAJOR MINOR <<< "${LastVersionString}"

MINOR=$(($MINOR + 1)) 

if [ "$MINOR" -ge 100  ]; then
	MAJOR=$(($MAJOR + 1)) 
	MINOR=$((0))
fi


ApplicationDir_Out_1="$OutputDataDir"/"apps"/"$ApplicationName_1"/"$MAJOR"".""$MINOR"/"windows_intelx86"
ApplicationDir_Out_2="$OutputDataDir"/"apps"/"$ApplicationName_1"/"$MAJOR"".""$MINOR"/"windows_x86_64"


mkdir -p "$ApplicationDir_Out_1"
cp -rf "$ApplicationDir"/. "$ApplicationDir_Out_1"/

mkdir -p "$ApplicationDir_Out_2"
cp -rf "$ApplicationDir"/. "$ApplicationDir_Out_2"/


if [ -d "$InputDataDir"/"$ApplicationFolderName_1" -a -f "$InputDataDir"/"$ApplicationFolderName_1"/"version.xml" ]; then

	cp -rf "$InputDataDir"/"$ApplicationFolderName_1"/"version.xml" "$ApplicationDir_Out_1"/
	cp -rf "$InputDataDir"/"$ApplicationFolderName_1"/"version.xml" "$ApplicationDir_Out_2"/
fi


# ---------------------------------------------- Copy jobs
make -C "$WorkGeneratorDir"
make -C "$ResultsValidatorDir"
make -C "$AsimilatorDir"

mkdir -p "$WorkGeneratorDir_Out"
find "$WorkGeneratorDir" -iname "*""$JobExecExtension" -exec cp {} "$WorkGeneratorDir_Out" \;

mkdir -p "$ResultsValidatorDir_Out"
find "$ResultsValidatorDir" -iname "*""$JobExecExtension" -exec cp {} "$ResultsValidatorDir_Out" \;

mkdir -p "$AsimilatorDir_Out"
find "$AsimilatorDir" -iname "*""$JobExecExtension" -exec cp {} "$AsimilatorDir_Out" \;


# ---------------------------------------------- Deploy 'OutputData' to Project folder

mkdir -p "$ProjectRootDir"
cp -rf "$OutputDataDir"/. "$ProjectRootDir"/

mkdir -p "$OutputBackupDir"/"Backup__""$datetime"
cp -rf "$OutputDataDir"/. "$OutputBackupDir"/"Backup__""$datetime"/


# ---------------------------------------------- Clear input folder

if [ ! -z "$InputDataDir" ]; then
	rm -rf "$InputDataDir"/*
fi

# ---------------------------------------------- Clear project log files

if [ ! -z "$ProjectRootDir" -a -d "$ProjectRootDir"/"log_localhost" ]; then
	rm -f "$ProjectRootDir"/"log_localhost"/*
fi


