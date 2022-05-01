#!/bin/bash
#usage
# bash ./driveCheck.sh [operation mode] [output option] <tempfile>
#or  source (can follow above pattern or specify $OM $OO $tmpMNTS)
#or run without to run internally
#Modes: list, mounts, dialog
#Outputs: display, file, variable 

#####  --- SETUP --- #####

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


#####  --- LOAD DRIVES --- #####
for i in ${!PART[@]}; do

#check UUID if attached output is drive letters
#found outputs sdx (or crypt mnt equiv)
FOUND=$(sudo blkid | grep UUID=\"${PART[$i]}\" | cut -d : -f 1 | rev | cut -d / -f 1 |rev )
if [[ $FOUND == '' ]]; then
	: #if no entry for UUID found it's not attached, move to next UUID
  else
	CRYPT_TEST=$(grep -w ${PART[$i]} /etc/crypttab | cut -d ' ' -f 1)
	A=$(lsblk -e7 -o UUID,MOUNTPOINT | grep ${PART[$i]} | awk '{print $2}')
	if [[ $CRYPT_TEST == '' ]]; then #check if crypt is possible
	     CRYPT_Y[$i]=0
	     if [[ $A == '' ]]; then #check if mounted
	   	  DMOUNT_Y[$i]=0
	   	  CMOUNT_Y[$i]=0
	       else
	 	  DMOUNT_Y[$i]=1
	 	  CMOUNT_Y[$i]=0
	 	  DRIVE_NUM[$i]=$(($i))
	 	  DRIVE_MNT[$i]=$A
	 	  DRIVE_DESC[$i]=${DESC[$i]}
	     fi
	  else
	     B=$(lsblk -e7 -o MOUNTPOINT,name | grep $CRYPT_TEST | awk '{print $1}')
	     CRYPT_Y[$i]=1
	     if [[ $B == '' ]]; then #check if mounted
	   	  DMOUNT_Y[$i]=0
	   	  CMOUNT_Y[$i]=0
	       else
	   	  DMOUNT_Y[$i]=1
	   	  CMOUNT_Y[$i]=1
	   	  DRIVE_NUM[$i]=$(($i))
	   	  DRIVE_MNT[$i]=$B
	 	  DRIVE_DESC[$i]=${DESC[$i]}
	     fi
	fi
fi
done

#####  --- CHECK DRIVES --- #####
for i in ${!DRIVE_NUM[@]}; do
File=()
File="${DRIVE_MNT[${DRIVE_NUM[$i]}]}/check.file"
if grep -q "${CHECK[${DRIVE_NUM[$i]}]}" "$File"; then
  DRIVE_AVAIL[${DRIVE_NUM[$i]}]=${DRIVE_MNT[${DRIVE_NUM[$i]}]}
else
  :
fi
done

#####  --- I/O PREP --- #####
##  -- Operation Mode -- ##
Manual_1Y=0
Manual_2Y=0
while true; do #1
if [[ -z $OM ]]; then
	if [[ -z $1 ]]; then
		Manual_1Y=1
		while true; do #1.1a
		echo -n "Enter Operation Mode:"
		read OM
		OM=$(echo "$OM" | awk '{print tolower($0)}')
		if [[ "$OM" == "list" ]] || [[ "$OM" == "mounts" ]] || [[ "$OM" == "dialog" ]]; then
			break 1 #1.1ax
		else
			echo "Error: must be a valid mode"
		fi
		done #1.1ax
		
	else
		OM=$1
		while true; do #1.1b
		OM=$(echo "$OM" | awk '{print tolower($0)}')
		if [[ "$OM" == "list" ]] || [[ "$OM" == "mounts" ]] || [[ "$OM" == "dialog" ]]; then
			break 1 #1.1bx
		else
			echo "Error: must be a valid mode"
			echo -n "Enter Operation Mode:"
			read OM
			OM=$(echo "$OM" | awk '{print tolower($0)}')
			Manual_1Y=1
		fi
		done #1.1bx
	fi
else
	:	
fi

##  -- Output Options -- ##
if [[ -z $OO ]]; then
	if [[ -z $2 ]]; then
		Manual_2Y=1
		while true; do #1.2a
		echo -n "Enter Output Option:"
		read OO
		OO=$(echo "$OO" | awk '{print tolower($0)}')
		if [[ "$OO" == "display" ]] || [[ "$OO" == "file" ]] || [[ "$OO" == "variable" ]]; then
			break 1 #1.2ax
		else
			echo "Error: must be a valid option1"
		fi
		done #1.2ax
		
	else
		OO=$2
		while true; do #1.2b
		OO=$(echo "$OO" | awk '{print tolower($0)}')
		if [[ "$OO" == "display" ]] || [[ "$OO" == "file" ]] || [[ "$OO" == "variable" ]]; then
			break 1 #1.2bx
		else
			echo "Error: must be a valid option2"
			echo -n "Enter Output Option:"
			read OO
			OO=$(echo "$OO" | awk '{print tolower($0)}')
			Manual_2Y=1
		fi
		done #1.2bx
	fi
else
	:	
fi
if [[ -z $tmpMNTS ]]; then
	if [[ -z $3 ]]; then
		tmpMNTS="tmpMNTS.txt"
	else
		tmpMNTS="$3"
	fi
else
	:
fi	

## -- Confirmation -- ##
if [[ "$Manual_1Y" == "1" ]] || [[ "$Manual_2Y" == "1" ]]; then
while true; do #1.1
echo ""
echo "_____________________________________________"
echo "Operation Mode: $OM"
echo "Output Option: $OO"
echo -n "Please confirm [y/n] if the above is correct."
echo ""
read check
check=$(echo "$check" | awk '{print tolower($0)}')
if [ "$check" == "" ]; then
   echo "Nothing was entered by the user!"
elif [[ "$check" == "cancel" ]] || [[ "$check" == "exit" ]]; then
   echo "Canceling..."
   sleep 3s
   exit
elif [[ "$check" == "redo" ]] || [[ "$check" == "n" ]] || [[ "$check" == "no" ]]; then
   OM=() OO=()
   break 1 #1.1x
elif [[ "$check" == "confirm" ]] || [[ "$check" == "y" ]] || [[ "$check" == "yes" ]]; then
   break 2 #1x.1x
else
   :
fi
done #1.1x
else
break #1x
fi
done #1x

#####  --- I/O ACTION --- #####
if [[ "$OO" == "file" ]]; then
touch "$tmpMNTS"
truncate -s 0 "$tmpMNTS"
fi
if [ "$OM" == "" ]; then
	echo "Error OM #1"
elif [[ "$OM" == "list" ]]; then
	if [[ "$OO" == "" ]]; then
		echo "Error OM=List: OO #1"
	elif [[ "$OO" == "display" ]]; then
		for i in ${!DRIVE_AVAIL[@]}; do
			echo "${DRIVE_NUM[$i]}) ${DRIVE_AVAIL[$i]}: ${DRIVE_DESC[$i]}"
		done
	elif [[ "$OO" == "file" ]]; then
		for i in ${!DRIVE_AVAIL[@]}; do
			echo "${DRIVE_NUM[$i]}) ${DRIVE_AVAIL[$i]}: ${DRIVE_DESC[$i]}" >> $tmpMNTS
		done
	elif [[ "$OO" == "variable" ]]; then
		for i in ${!DRIVE_AVAIL[@]}; do
			MOUNT_POINTS[$i]="${DRIVE_NUM[$i]}) ${DRIVE_AVAIL[$i]}: ${DRIVE_DESC[$i]}"
		done
	else
		echo "Error OM=List: OO #2"
	fi
elif [[ "$OM" == "mounts" ]]; then
	if [[ "$OO" == "" ]]; then
		echo "Error OM=mounts: OO #1"
	elif [[ "$OO" == "display" ]]; then
		for i in ${!DRIVE_AVAIL[@]}; do
			echo "${DRIVE_AVAIL[$i]}"
		done
	elif [[ "$OO" == "file" ]]; then
		for i in ${!DRIVE_AVAIL[@]}; do
			echo "${DRIVE_AVAIL[$i]}" >> $tmpMNTS
		done
	elif [[ "$OO" == "variable" ]]; then
		for i in ${!DRIVE_AVAIL[@]}; do
			MOUNT_POINTS[$i]="${DRIVE_AVAIL[$i]}"
		done
	else
		echo "Error OM=mounts: OO #2"	
	fi
elif [[ "$OM" == "dialog" ]]; then
	if [[ "$OO" == "" ]]; then
		echo "Error OM=dialog: OO #1"
	elif [[ "$OO" == "display" ]]; then
		for i in ${!DRIVE_AVAIL[@]}; do
			echo "${DRIVE_NUM[$i]} \"${DRIVE_AVAIL[$i]}\" off"
		done
	elif [[ "$OO" == "file" ]]; then
		for i in ${!DRIVE_AVAIL[@]}; do
			echo "${DRIVE_NUM[$i]} \"${DRIVE_AVAIL[$i]}\" off" >> $tmpMNTS
		done
	elif [[ "$OO" == "variable" ]]; then
		for i in ${!DRIVE_AVAIL[@]}; do
			MOUNT_POINTS[$i]="${DRIVE_NUM[$i]} \"${DRIVE_AVAIL[$i]}\" off"
		done
	else
		echo "Error OM=dialog: OO #2"	
	fi
else
	echo "Error OM #2"
fi

#Version_1.00
#Version_Code.MinorChanges

#Change Log:

#1.00: Initial release (srv)
