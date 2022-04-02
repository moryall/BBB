#!/bin/bash

# -- Set Up -- #
#grab other variables
source ./code/var.sh
#grabs one level up for Constant Working Directory
cwd=${PWD%/*} 
#SouRCe Directory for shorter refernce to logs and code
srcd=$(pwd)
#grabs user name while non-sudo
N=$(whoami)
#create Date Code for files (persistent through batch)
DC=$(date +%Y-%m-%d)

# -- Intro -- #
clear
echo ""
echo ""
echo "Welcome to Bodged Bash Backup!"
echo ""
echo ""

#Auto version comparison
echo "Checking if dependencies are installed..."
source ./code/versionCheck.sh
echo "All dependencies are met."
echo ""


# -- Set Up -- #
echo "Setting up files..."
#silent creation of logs and temp folders
exec 3>&2
exec 2> /dev/null
#create folders if none already exist; most likely to error hence silence.
if [ -d "$FL1" ]; then
echo "" ;
else
`mkdir -p $FL1`;
fi
if [ -d "$FL2" ]; then
echo "" ;
else
`mkdir -p $FL2`;
fi
#files
tmpA="$srcd$SL$FL2$SL$Wd4-cwd$Ext1"
tmpB="$srcd$SL$FL2$SL$Wd4-srcd$Ext1"
tmpC="$srcd$SL$FL2$SL$Wd4-N$Ext1"
tmpD="$srcd$SL$FL2$SL$Wd4-DC$Ext1"
touch "$tmpA"
touch "$tmpB"
touch "$tmpC"
touch "$tmpD"
echo "$cwd" > "$tmpA"
echo "$srcd" > "$tmpB"
echo "$N" > "$tmpC"
echo "$DC" > "$tmpD"
exec 2>&3 #end silence

# -- Run Program -- #

echo ""
echo "Starting Program..."
sudo bash ./$FL3$SL$Prog00
echo ""
echo "All Done."
echo -n "Press [ENTER] to close program"
read var_blank
echo "closing Backup-RUN..."
sleep 5s
exit


#Version_1.00
#Version_Code.MinorChanges

#Change Log:
#2.00 Added code to grab and pass user name, and script choices to files in anticipation of one file to run TAR and RSYNC with passed options until another method of running sudo safely for long periods is trialed. 
#	CP is depricated with use of rsync and no longer provided. 
#	Backups designed to fill folders below location Program Folder files in their own folder and will backup ../ to location program folder is in. 
#	Will make dir if no dir.
#	All logs dropped in log folder.
#	Config file as common variables
#	Auto-version checker added in
#1.00 no version numbers, previously named "Backup-RUN.sh" See archived versions.





