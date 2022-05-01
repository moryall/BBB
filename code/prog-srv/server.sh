#!/bin/bash

PRGNM="Server Backup"
Ver="1.0.0"

#####  --- SETUP --- #####
DC=$(date +%Y-%m-%d)

#Drives and Checks
PART[0]="" ; DESC[0]="SBU-01"
CHECK[0]='VCMBH,9Smy_@Kk6YTrU3U.f=/q5Phl#s'
PART[1]="" ; DESC[1]="SBU-02"
CHECK[1]=',f@sinuRa1adJA%9.\CL8pH-rSUX_m\='
PART[2]="" ; DESC[2]="CBU-01"
CHECK[2]='Qc:LT>>.v0pPBWn\52qx8zEkX3bH7Nr1'
#PART[3]="" ; DESC[3]=""
#CHECK[3]='e\-LmO<65Cd%Sw7@Ir.n^0Vf:/gYUaDF'
#CHECK[4]='u:3eXtT70_%z.6-a^Lv=qjHFS/AnNEGB'
#CHECK[5]='QJ=s,cY89HPqFuzm^3+b@Y^:rzw11/fi'
#CHECK[6]='Os+pH4m1o7-j<uN#&M0>Rq1Lr9PbtxTX'
#CHECK[7]='M0N_q6RK2#=TWBhAZYQgt&Jvp6P3%E,n'


## -- Make Logs -- ##
logFolder="/home/server/logs"
if [ -d "$logFolder" ]; then echo "" ; else `mkdir -p $logFolder`; fi #logs
logFileName="_BKUP-log"
log="$logFolder$DC$logFileName"
if [[ -e $log.txt || -L $log.txt ]] ; then
    i=0
    while [[ -e $log-$i.txt || -L $log-$i.txt ]] ; do
        let i++
    done
    log=$log-$i
fi
log="$log.txt" #add extension after possibly a number
#make log headers
printf "Log File - " > "$log"
date >> "$log"
echo "$PRGNM version $Ver" >> "$log"
echo "" >> "$log"




#####  --- CHECK DRIVES --- #####
if grep -q "/mnt/SBU-01/check.file" "${CHECK[0]}"; then
    DRIVE[0]=1 
    echo "Drive: SBU-01 is attached" | tee -a "$log"
  else
    DRIVE[0]=0
fi
if grep -q "/mnt/SBU-02/check.file" "${CHECK[1]}"; then
    DRIVE[1]=1
    echo "Drive: SBU-02 is attached" | tee -a "$log"
  else
    DRIVE[1]=0
fi
if grep -q "/mnt/CBU-01/check.file" "${CHECK[2]}"; then
    DRIVE[2]=1
    echo "Drive: CBU-01 is attached" | tee -a "$log"
  else
    DRIVE[2]=0
fi

echo "" | tee -a "$log"
echo ""


#force question if drive with services on it need to be backed up, can't skip
if [[ "${DRIVE[0]}" == "1" ]] || [[ "${DRIVE[2]}" == "1" ]]; then
    while true; do #1
    echo -n "Permit interuption to service?"
    echo ""
    read check
    check=$(echo "$check" | awk '{print tolower($0)}')
    if [ "$check" == "" ]; then
        echo "Nothing was entered by the user!"
    elif [[ "$check" == "cancel" ]] || [[ "$check" == "exit" ]] || [[ "$check" == "n" ]] || [[ "$check" == "no" ]]; then
        echo "Canceling..."
        sleep 3s
        exit
    elif [[ "$check" == "confirm" ]] || [[ "$check" == "y" ]] || [[ "$check" == "yes" ]]; then
        break 1 #1x
    else
        :
    fi
    done #1
fi


#backup per drive
if [[ "${DRIVE[0]}" == "1" ]]; then
    echo "____________________________"
    echo "Backing up D14T-01 to SBU-01" | tee -a "$log"
    echo "" | tee -a "$log"
    echo "--" | tee -a "$log"
    echo "Stopping Plex Service" | tee -a "$log"
    service plexmediaserver stop
    echo "Backing up Plex DB" | tee -a "$log"
    OP="${DC}_Plex.tgz"
    echo "DB File Name:\"$OP\"" >> tee -a "$log"
    cd /srv/D14T-01/PlexDB-BKUP
    tar cvpzf $OP --exclude='/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Cache' '/var/lib/plexmediaserver/Library/Application Support/Plex Media Server'
    cp -TRuPv $OP /mnt/SBU-01/PlexDB-BKUP
    echo "Plex DB backup complete" | tee -a "$log"
    echo "Starting Plex Service" | tee -a "$log"
    service plexmediaserver start
    echo "" | tee -a "$log"
    echo "--" | tee -a "$log"
    echo "Backing up Plex1" | tee -a "$log"
    rsync -aEhi --delete --progress /srv/D14T-01/Plex1 /mnt/SBU-01
    echo "Plex1 backup complete" | tee -a "$log"
    echo "D14T-01 to SBU-01 COMPLETE" | tee -a "$log"
    echo "" | tee -a "$log"
    echo "" | tee -a "$log"
else
    :
fi

if [[ "${DRIVE[1]}" == "1" ]]; then
    echo "____________________________"
    echo "Backing up D14T-02 to SBU-02" | tee -a "$log"
    echo "" | tee -a "$log"
    echo "--" | tee -a "$log"
    echo "Backing up Plex2" | tee -a "$log"
    rsync -aEhi --delete --progress /srv/D14T-02/Plex2 /mnt/SBU-02
    echo "Plex2 backup complete" | tee -a "$log"
    echo "D14T-02 to SBU-02 COMPLETE" | tee -a "$log"
    echo "" | tee -a "$log"
    echo "" | tee -a "$log"
else
    :
fi

if [[ "${DRIVE[2]}" == "1" ]]; then
    echo "____________________________"
    echo "Backing up D04T-01 to CBU-01" | tee -a "$log"
    echo "" | tee -a "$log"
    echo "--" | tee -a "$log"
    echo "Stopping NextCloud Service" | tee -a "$log"
    cd /srv/D04T-01/www/iluvatardis/nextcloud
    runuser -u www-data php occ maintenance:mode --on
    echo "Backing up NC Data" | tee -a "$log"
    #rsync -Aavx nextcloud/ nextcloud-dirbkp_`date +"%Y%m%d"`/
    rsync -AEhavx /srv/D04T-01/NC-Data /mnt/CBU-01
    echo "NC Data backup complete" | tee -a "$log"
    echo "Backing up www Data" | tee -a "$log"
    rsync -AEhavx /srv/D04T-01/www /mnt/CBU-01
    echo "www backup complete" | tee -a "$log"
    echo "Starting NextCloud Service" | tee -a "$log"
    runuser -u www-data php occ maintenance:mode --off
    echo "D04T-01 to CBU-01 Partially completed" | tee -a "$log"
    echo "To complete NC backup:" | tee -a "$log"
    echo "1) maintenance mode: sudo -u www-data php occ maintenance:mode --on" | tee -a "$log"
    echo "2) db backup: mysqldump --single-transaction -u cloudAdm -p [password] nextcloud > nextcloud-sqlbkp_`date +"%Y%m%d"`.bak" | tee -a "$log"
    echo "" | tee -a "$log"
    echo "" | tee -a "$log"
else
    :
fi

echo "Backups Complete"
echo -n "Press [ENTER] to close program"
read var_blank
exit

#Version_1.0.0

#Change Log:
#1.0.0: Initial release
