#!/bin/bash

printf '\e[8;40;120t'
#  --- FILE SETUP --- #

#grab other variables
source ./code/var.sh

# - Load Temp - #
bk=$(pwd)
#temp files locations
tmpA="$bk$SL$FL2$SL$Wd4-cwd$Ext1"
tmpB="$bk$SL$FL2$SL$Wd4-srcd$Ext1"
tmpC="$bk$SL$FL2$SL$Wd4-N$Ext1"
tmpD="$bk$SL$FL2$SL$Wd4-DC$Ext1"
#load in temp var
cwd=$(<"$tmpA")
srcd=$(<"$tmpB")
N=$(<"$tmpC")
DC=$(<"$tmpD")

# - Make Logs - #
#log file locations
log=$srcd$SL$FL1$SL$DC$Sp3$Wd2
debug=$srcd$SL$FL1$SL$DC$Sp3$Wd3

#check if already, if yes add number
if [[ -e $log.txt || -L $log.txt ]] ; then
    i=0
    while [[ -e $log-$i.txt || -L $log-$i.txt ]] ; do
        let i++
    done
    log=$log-$i
fi
log="$log$Ext1"
if [[ -e $debug.txt || -L $debug.txt ]] ; then
    i=0
    while [[ -e $debug-$i.txt || -L $debug-$i.txt ]] ; do
        let i++
    done
    debug=$debug-$i
fi
debug="$debug$Ext1"

#log headers
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

#call main body
source ./code/prog-hm/dialog.sh




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

#1.00: Version Original version
