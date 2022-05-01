#!/bin/bash
##### -- Set Up -- #####
#grab other variables
source ./code/com.sh
source ./code/var.sh
#make variables
cwd=${PWD%/*} #grabs one level up for Constant Working Directory
srcd=$(pwd) #SouRCe Directory for shorter refernce to logs and code
N=$(whoami) #grabs user name while non-sudo
DC=$(date +%Y-%m-%d) #create Date Code for files (persistent through batch)



##### -- Intro -- #####
clear
echo ""
echo ""
echo "Welcome to Bodged Bash Backup!"
echo ""
echo ""


### -- Auto Version Comparison -- ###
echo "Checking if dependencies are installed..."
source ./code/prog-cm/versionCheck.sh
echo "All dependencies are met."
echo ""


### -- Folders and Temp Files -- ###
echo "Setting up files..."
exec 3>&2 #Make Backup of 2 on 3.
exec 2> /dev/null #silent creation of logs and temp folders by dumping 2 into null

## - Folder Creation - ## 
if [ -d "$FL1" ]; then echo "" ; else `mkdir -p $FL1`; fi #logs
if [ -d "$FL2" ]; then echo "" ; else `mkdir -p $FL2`; fi #temp

## - File Creation - ## 
#Generate file names
tmpA="$srcd$SL$FL2$SL$Wd4-cwd$Ext1" #holds Constant Working Directory
tmpB="$srcd$SL$FL2$SL$Wd4-srcd$Ext1" #holds SouRCe Directory
tmpC="$srcd$SL$FL2$SL$Wd4-N$Ext1" #holds user name
tmpD="$srcd$SL$FL2$SL$Wd4-DC$Ext1" #holds Date Code
#Generate Files with specified location/names
touch "$tmpA"
touch "$tmpB"
touch "$tmpC"
touch "$tmpD"
#Write variables to appropriate temp file
echo "$cwd" > "$tmpA"
echo "$srcd" > "$tmpB"
echo "$N" > "$tmpC"
echo "$DC" > "$tmpD"
#end silence
exec 2>&3



##### -- Master Program -- #####
#open
echo ""
echo "Starting Program..."
sudo ./code/prog-cm/dialogDisplay.sh start ./code/prog-cm/
sudo bash ./$FL3$SL$Prog00 #runs master.sh (check var)

#clean
echo "closing BKUP-RUN..."
sudo ./code/prog-cm/dialogDisplay.sh stop ./code/prog-cm/
rm "$tmpA"
rm "$tmpB"
rm "$tmpC"
rm "$tmpD"
rmdir "$srcd$SL$FL2"

#close
echo ""
echo -n "Press [ENTER] to close program"
read var_blank
exit


#Version_1.00
#Version_Code.MinorChanges

#Change Log:

#2.03: Added dialogDisplay start and stop.
#2.02: Cleaned code and clarified comments. Added removal of temp files.
#2.01: Updated to reflect new directory structure
#2.00: Added code to grab and pass user name, and script choices to files in anticipation of one file to run TAR and RSYNC with passed options until another method of running sudo safely for long periods is trialed. 
#	CP is depricated with use of rsync and no longer provided. 
#	Backups designed to fill folders below location Program Folder files in their own folder and will backup ../ to location program folder is in. 
#	Will make dir if no dir.
#	All logs dropped in log folder.
#	Config file as common variables
#	Auto-version checker added in
#1.00: no version numbers, previously named "Backup-RUN.sh" See archived versions.
