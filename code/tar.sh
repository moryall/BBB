#!/bin/bash
#Program Name
PRGNM="BKUP_tar"
Ver="5.01"

#  --- FILE SETUP ---
#Nearly all done in 'dialog' which will pull this program

# - PATH - #
#pathin with usr name
#should be dynamic equivilant to: PATHIN=/home/michael/
PATHIN="$FL0$N$SL"

#pathout dynamic
PATHOUT=$cwd$SL$Wd6

cd "$cwd"
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
		T101a="HM-Root"
		OP101a="$DC$Sp3$Wd1$Sp3$T101a$Ext2"
		echo "tar cvpzf $OP101a --exclude=/proc --exclude=/lost+found --exclude=/mnt --exclude=/sys --exclude=/media --exclude=/run --exclude=/dev --exclude=/srv --exclude=/home --exclude=/boot --exclude=/tmp /"
		echo "Backing up Boot (i.e. /boot)" | tee -a "$log" | tee -a "$debug"
		T101b="HM-Boot"
		OP101b="$DC$Sp3$Wd1$Sp3$T101b$Ext2"
		echo "tar cvpzf $OP101b /boot"
		echo "Root Complete - $(date)" | tee -a "$log" | tee -a "$debug"
		INPUT=()
		echo "___" | tee -a "$log" | tee -a "$debug"
		echo "" | tee -a "$log" | tee -a "$debug"
		;;		
        2)
		echo "--Backing up Home Hidden Folders" | tee -a "$log" | tee -a "$debug"
		for i4 in ${!HID[@]}; do
  			INPUT+="$PATHIN${HID[$i4]}$Sp0"
  		done
		T102="HM-HFS(H)"
		OP102="$DC$Sp3$Wd1$Sp3$T102$Ext2"
		E="$PATHIN.local/share/Steam"
		echo "tar cvpzf $OP102 --exclude=$E $INPUT" | tee -a "$debug"
		echo "Home Hidden Folders Complete - $(date)" | tee -a "$log" | tee -a "$debug"
		INPUT=()
		echo "___" | tee -a "$log" | tee -a "$debug"
		echo "" | tee -a "$log" | tee -a "$debug"
		;;
	3)
		echo "--Backing up Home Visible Files" | tee -a "$log" | tee -a "$debug"
		INPUT="$PATHIN$Sp4"
		T103="HM-HFS(V)"
		OP103="$DC$Sp3$Wd1$Sp3$T103$Ext2"
		echo "tar cvpzf $OP103 --no-recursion $INPUT" | tee -a "$debug"
		echo "Home Visible Files Complete - $(date)" | tee -a "$log" | tee -a "$debug"
		INPUT=()
		echo "___" | tee -a "$log" | tee -a "$debug"
		echo "" | tee -a "$log" | tee -a "$debug"
		;;
        4)
		echo "--Backing up Games" | tee -a "$log" | tee -a "$debug"
		for i4 in ${!GameAr[@]}; do
  			INPUT+="$PATHIN${GameAr[$i4]}$Sp0"
  		done
  		T104="HM-Games"
		OP104="$DC$Sp3$Wd1$Sp3$T104$Ext2"
  		echo "tar cvpzf $OP104 $INPUT" | tee -a "$debug"
		echo "Games Complete - $(date)" | tee -a "$log" | tee -a "$debug"
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
	T200="HM-${CFB2[i5]}"
	OP200="$DC$Sp3$Wd1$Sp3$T200$Ext2"
	echo "tar -cvzf - $INPUT | split -b 40000M - $OP200" | tee -a "$debug"
	echo "${CFB1[i5]} is Complete - $(date)" | tee -a "$log" | tee -a "$debug"
	INPUT=()
	echo "___" | tee -a "$log" | tee -a "$debug"
	echo "" | tee -a "$log" | tee -a "$debug"
done

#Version_1.00
#Version_Code.MinorChanges

#Change Log:

#5.01: Minor tweaks with quotes around folder creation.
#5.00: updated for BKUP_RUN / BBB 1.00.00 intial release. 
#4.01: added "complete" message to make log clearer.
#4.00: added dialog, including checkboxes! added log and debug. FldB options 1-stop add! Complex backup use Options A.  
#3.00: Simplified grabbing files from /home root; no longer will grab all folders, MUST list folders to preserve as new entries.
#2.02: made folders match closer to cp_v2.
#2.01: Made Documents and School seperate from HFS; excluded ARCHIVE from HFS, excluded .local/share/Steam from HFS(H).
#2.00: Branch created removed sudo, must use companion app to eliviate sudo time out.
#1.00: Created






