#!/bin/bash
#Program Name
PRGNM="BKUP_rsycn"
Ver="2.03"

#  --- FILE SETUP ---
#Nearly all done in 'dialog' which will pull this program

# - PATH - #
PATHIN="$SL$FL0$SL$N$SL" #should be dynamic equivilant to: PATHIN=/home/user/
PATHOUT="$cwd$SL$Wd5" #pathout dynamic

if [ -d "$cwd$SL$Wd5" ]; then
echo "" ;
else
`mkdir -p "$cwd$SL$Wd5"`;
fi

# --- BODY --- #
#Folders A
echo "### FOLDERS A ###" | tee -a "$log" >> "$debug"
echo "" >> "$debug"

for OutA1 in $OutA1
do
    case $OutA1 in
        1)
		echo "Option 1 = NULL" | tee -a "$log" | tee -a "$debug"
		;;		
        2)
		echo "--Backing up Home Hidden Folders" | tee -a "$log" | tee -a "$debug"
		for i4 in ${!HID[@]}; do
			echo "-Backing up ${HID[i4]}" | tee -a "$log" | tee -a "$debug"
			INPUT="$PATHIN${HID[i4]}$SL"
			OUTPUT="$PATHOUT$SL${HID[i4]}"
			E="$PATHIN.local/share/Steam"
			echo "Input:$INPUT  Output:$OUTPUT" | tee -a "$debug"
			echo "mkdir -p $OUTPUT"
			rsync -aEhi --progress --exclude \'$E\' $RS_Options$INPUT $OUTPUT
		done
		echo "Home Hidden Folders Complete - $(date)" | tee -a "$log" | tee -a "$debug"
		INPUT=()
		OUTPUT=()
		echo "___" | tee -a "$log" | tee -a "$debug"
		echo "" | tee -a "$log" | tee -a "$debug"
		;;
	3)
		echo "--Backing up Home Visible Files" | tee -a "$log" | tee -a "$debug"
		INPUT="$PATHIN"
		OUTPUT="$PATHOUT"
		echo "Input:$INPUT  Output:$OUTPUT" | tee -a "$debug"
		rsync -aEhi --exclude='*/' --progress $RS_Options$INPUT $OUTPUT
		echo "Home Visible Files Complete - $(date)" | tee -a "$log" | tee -a "$debug"
		INPUT=()
		OUTPUT=()
		echo "___" | tee -a "$log" | tee -a "$debug"
		echo "" | tee -a "$log" | tee -a "$debug"
		;;
        4)
		echo "--Backing up Games" | tee -a "$log" | tee -a "$debug"
		for i4 in ${!GameAr[@]}; do
			echo "-Backing up ${GameAr[i4]}" | tee -a "$log" | tee -a "$debug"
			INPUT="$PATHIN${GameAr[i4]}"
			OUTPUT="$PATHOUT"
			echo "Input:$INPUT  Output:$OUTPUT" | tee -a "$debug"
			echo "mkdir -p $OUTPUT"
			rsync -aEhi --progress $RS_Options$INPUT $OUTPUT
		done
		echo "Games Complete - $(date)" | tee -a "$log" | tee -a "$debug"
		INPUT=()
		OUTPUT=()
		echo "___" | tee -a "$log" | tee -a "$debug"
		echo "" | tee -a "$log" | tee -a "$debug"
		;;
    esac
done

echo "### FOLDERS B ###" | tee -a "$log" >> "$debug"
echo "" >> "$debug"

#Program Choices B
for i5 in ${!CFB1[@]}; do
	echo "--Backing up ${CFB1[i5]}" | tee -a "$log" | tee -a "$debug"
	INPUT="$PATHIN${CFB1[i5]}"
	OUTPUT="$PATHOUT"
	rsync -aEhi --progress $RS_Options$INPUT $OUTPUT
	echo "${CFB1[i5]} is Complete - $(date)" | tee -a "$log" | tee -a "$debug"
	INPUT=()
	OUTPUT=()
	echo "___" | tee -a "$log" | tee -a "$debug"
	echo "" | tee -a "$log" | tee -a "$debug"
done

#Version_1.00
#Version_Code.MinorChanges

#Change Log:
#2.03: adjusted variables for overhaul of diaglog.
#2.02: fixed erroneous folder creation. Fixed lack of parent folders for hidden & games.
#2.01: fixed rsync bug for A-2. Now it keeps directory structure for all hidden folders being backed up.
#2.00: updated for BKUP_RUN / BBB 1.00.00 intial release.
#1.00: Created matched CP_v3 & Tar_v4.
