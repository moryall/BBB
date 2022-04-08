#!/bin/bash
#Program Name
PRGNM="BKUP_tar"
Ver="5.02"

#  --- FILE SETUP ---
#Nearly all done in 'dialog' which will pull this program

# - PATH - #
PATHIN="$SL$FL0$SL$N$SL" #should be dynamic equivilant to: PATHIN=/home/user/
PATHOUT="$cwd$SL$Wd6" #pathout dynamic

cd "$cwd" #change to working directory
if [ -d "$Wd6" ]; then
echo "" ;
else
`mkdir -p "$Wd6"`;
fi
cd "$Wd6" #working directory will be in tar output folder
echo "Directory changed to:" >> "$debug"
echo "$PATHOUT" >> "$debug"
echo "" >> "$debug"

# --- BODY --- #
#Folders A
echo "### FOLDERS A ###" | tee -a "$log" >> "$debug"
echo "" >> "$debug"

for OutA2 in $OutA2
do
    case $OutA2 in
        1)
		echo "--Backing up Root (i.e. /)" | tee -a "$log" | tee -a "$debug"
		TITLE="HM-Root"
		OP_LOC="$DC$Sp3$Wd1$Sp3$TITLE$Ext2"
		echo "tar cvpzf $OP_LOC --exclude=/proc --exclude=/lost+found --exclude=/mnt --exclude=/sys --exclude=/media --exclude=/run --exclude=/dev --exclude=/srv --exclude=/home --exclude=/boot --exclude=/tmp /"
		TITLE=()
		OP_LOC=()
		echo "Backing up Boot (i.e. /boot)" | tee -a "$log" | tee -a "$debug"
		TITLE="HM-Boot"
		OP_LOC="$DC$Sp3$Wd1$Sp3$TITLE$Ext2"
		echo "tar cvpzf $OP_LOC /boot"
		echo "Root Complete - $(date)" | tee -a "$log" | tee -a "$debug"
		TITLE=()
		OP_LOC=()
		echo "___" | tee -a "$log" | tee -a "$debug"
		echo "" | tee -a "$log" | tee -a "$debug"
		;;		
        2)
		echo "--Backing up Home Hidden Folders" | tee -a "$log" | tee -a "$debug"
		for i4 in ${!HID[@]}; do
  			INPUT+="$PATHIN${HID[$i4]}$Sp0"
  		done
		TITLE="HM-HFS(H)"
		OP_LOC="$DC$Sp3$Wd1$Sp3$TITLE$Ext2"
		E="$PATHIN.local/share/Steam"
		echo "tar cvpzf $OP_LOC --exclude=$E $INPUT" | tee -a "$debug"
		echo "Home Hidden Folders Complete - $(date)" | tee -a "$log" | tee -a "$debug"
		TITLE=()
		OP_LOC=()
		INPUT=()
		echo "___" | tee -a "$log" | tee -a "$debug"
		echo "" | tee -a "$log" | tee -a "$debug"
		;;
	3)
		echo "--Backing up Home Visible Files" | tee -a "$log" | tee -a "$debug"
		INPUT="$PATHIN$Sp4"
		TITLE="HM-HFS(V)"
		OP_LOC="$DC$Sp3$Wd1$Sp3$TITLE$Ext2"
		echo "tar cvpzf $OP_LOC --no-recursion $INPUT" | tee -a "$debug"
		echo "Home Visible Files Complete - $(date)" | tee -a "$log" | tee -a "$debug"
		TITLE=()
		OP_LOC=()
		INPUT=()
		echo "___" | tee -a "$log" | tee -a "$debug"
		echo "" | tee -a "$log" | tee -a "$debug"
		;;
        4)
		echo "--Backing up Games" | tee -a "$log" | tee -a "$debug"
		for i4 in ${!GameAr[@]}; do
  			INPUT+="$PATHIN${GameAr[$i4]}$Sp0"
  		done
  		TITLE="HM-Games"
		OP_LOC="$DC$Sp3$Wd1$Sp3$TITLE$Ext2"
  		echo "tar cvpzf $OP_LOC $INPUT" | tee -a "$debug"
		echo "Games Complete - $(date)" | tee -a "$log" | tee -a "$debug"
		TITLE=()
		OP_LOC=()
		INPUT=()
		echo "___" | tee -a "$log" | tee -a "$debug"
		echo "" | tee -a "$log" | tee -a "$debug"
		;;
    esac
done

echo "### FOLDERS B ###" | tee -a "$log" >> "$debug"
echo "" >> "$debug"

#Program Choices B
for i5 in ${!CFB2[@]}; do
	echo "--Backing up ${CFB2[i5]}" | tee -a "$log" | tee -a "$debug"
	INPUT="$PATHIN${CFB2[i5]}"
	TITLE="HM-${CFB2[i5]}"
	OP_LOC="$DC$Sp3$Wd1$Sp3$TITLE$Ext2"
	echo "tar -cvzf - $INPUT | split -b 40000M - $OP_LOC" | tee -a "$debug"
	echo "${CFB1[i5]} is Complete - $(date)" | tee -a "$log" | tee -a "$debug"
	TITLE=()
	OP_LOC=()
	INPUT=()
	echo "___" | tee -a "$log" | tee -a "$debug"
	echo "" | tee -a "$log" | tee -a "$debug"
done

#Version_1.00
#Version_Code.MinorChanges

#Change Log:

#5.02: adjusted variables for overhaul of diaglog.
#5.01: Minor tweaks with quotes around folder creation.
#5.00: updated for BKUP_RUN / BBB 1.00.00 intial release.
#4.01: added "complete" message to make log clearer.
#4.00: added dialog, including checkboxes! added log and debug. FldB options 1-stop add! Complex backup use Options A.  
#3.00: Simplified grabbing files from /home root; no longer will grab all folders, MUST list folders to preserve as new entries.
#2.02: made folders match closer to cp_v2.
#2.01: Made Documents and School seperate from HFS; excluded ARCHIVE from HFS, excluded .local/share/Steam from HFS(H).
#2.00: Branch created removed sudo, must use companion app to eliviate sudo time out.
#1.00: Created.
