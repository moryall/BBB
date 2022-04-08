#!/bin/bash

#####  --- FILE SETUP --- #####
#Make screen corect size
printf '\e[8;40;120t'
#grab other variables
source ./code/var.sh
source ./code/com.sh

## -- Load Temp -- ##
CL=$(pwd) #get Current Location. Temp file is more reliable.
#Regenerate temp file locations (Should match BKUP-RUN with srcd=CL)
tmpA="$CL$SL$FL2$SL$Wd4-cwd$Ext1"
tmpB="$CL$SL$FL2$SL$Wd4-srcd$Ext1"
tmpC="$CL$SL$FL2$SL$Wd4-N$Ext1"
tmpD="$CL$SL$FL2$SL$Wd4-DC$Ext1"
#load in temp var
cwd=$(<"$tmpA")
srcd=$(<"$tmpB")
N=$(<"$tmpC")
DC=$(<"$tmpD")

## -- Make Logs -- ##
#log file locations
log=$srcd$SL$FL1$SL$DC$Sp3$Wd2 #should be $srcd/logs/yyyy-mm-dd_Log
debug=$srcd$SL$FL1$SL$DC$Sp3$Wd3 #should be $srcd/logs/yyyy-mm-dd_Debug

#check if already made; if yes add number
if [[ -e $log.txt || -L $log.txt ]] ; then
    i=0
    while [[ -e $log-$i.txt || -L $log-$i.txt ]] ; do
        let i++
    done
    log=$log-$i
fi
log="$log$Ext1" #add extension after possibly a number

if [[ -e $debug.txt || -L $debug.txt ]] ; then
    i=0
    while [[ -e $debug-$i.txt || -L $debug-$i.txt ]] ; do
        let i++
    done
    debug=$debug-$i
fi
debug="$debug$Ext1" #add extension after possibly a number

#make log headers
printf "Log File - " | tee "$log" > "$debug"
date | tee -a "$log" >> "$debug"
echo "$PRGNM version $Ver" | tee -a "$log" >> "$debug"
echo "User: $N" | tee -a "$log" >> "$debug"
echo "File Location:" | tee -a "$log" >> "$debug"
echo "$srcd" | tee -a "$log" >> "$debug"
echo "" | tee -a "$log" >> "$debug"
echo "Working Directory:" | tee -a "$log" >> "$debug"
echo "$cwd" | tee -a "$log" >> "$debug"
echo "" | tee -a "$log" >> "$debug"



##### --- PULL MAIN PROGRAM --- #####
source ./code/prog-hm/dialog.sh



##### --- Finish --- #####
echo "" | tee -a "$log" | tee -a "$debug"
echo "Finished Backup" | tee -a "$log" | tee -a "$debug"
echo ""
printf "Completed at - $(date)" | tee -a "$log" >> "$debug"
echo "Thank you for backing up your files."
echo "Please place these files in a safe location."
exit

#Version_1.00
#Version_Code.MinorChanges

#Change Log:

#1.02: Cleaned up code comments
#1.01: Corrected for var/com split
#1.00: Version Original version
