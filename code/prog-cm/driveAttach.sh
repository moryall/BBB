#!/bin/bash
#####  --- SETUP --- #####

#keep partition UUID & description here
PART[0]="c06d5ea5-f492-45dc-8640-bbf59c2dd991" ; DESC[0]="Cheap Drive"
PART[1]="a1b94d33-975a-4f8e-94b8-2b1aa5e9e0e9" ; DESC[1]="WD BKUP"

#simple start
printf '\e[8;40;120t'
clear

#####  --- LOAD DRIVES --- #####
for i in ${!PART[@]}; do

#check UUID if attached output is drive letters
#found=outputs "sdX" (or crypt mnt equiv)
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
	   	  MNT_U[$i]=${PART[$i]} #UUID
	      	  MNT_L[$i]=$FOUND #Location (lsblk=name)
	      	  MNT_N[$i]=$(($i)) #number on list
	      	  MNT_D[$i]=${DESC[$i]} #description
	      	  MNT_M[$i]=''
	       else
	 	  DMOUNT_Y[$i]=1
	 	  CMOUNT_Y[$i]=0
	 	  UMNT_U[$i]=${PART[$i]} #UUID
	      	  UMNT_L[$i]=$FOUND #Location (lsblk=name)
	      	  UMNT_N[$i]=$(($i)) #number on list
	      	  UMNT_D[$i]=${DESC[$i]} #description
	      	  UMNT_M[$i]=$A #is mount point
	     fi
	  else
	     B=$(lsblk -e7 -o MOUNTPOINT,name | grep $CRYPT_TEST | awk '{print $1}')
	     CRYPT_Y[$i]=1
	     if [[ $B == '' ]]; then #check if mounted
	   	  DMOUNT_Y[$i]=0
	   	  CMOUNT_Y[$i]=0
	   	  MNT_U[$i]=${PART[$i]} #UUID
	   	  MNT_L[$i]=$FOUND #Location (lsblk=name)
	   	  MNT_N[$i]=$(($i)) #number on list
	   	  MNT_D[$i]=${DESC[$i]} #description
	   	  MNT_M[$i]='' #is mount point
	   	  MNT_CL[$i]=$CRYPT_TEST #Location (lsblk=name) but crypt
	   	  UMNT_U[$i]=${PART[$i]} #UUID
	   	  UMNT_L[$i]=$FOUND #Location (lsblk=name)
	   	  UMNT_N[$i]=$(($i)) #number on list
	   	  UMNT_D[$i]=${DESC[$i]} #description
	   	  UMNT_M[$i]=''
	   	  UMNT_CL[$i]=$CRYPT_TEST #Location (lsblk=name) but crypt
	       else
	   	  DMOUNT_Y[$i]=1
	   	  CMOUNT_Y[$i]=1
	   	  UMNT_U[$i]=${PART[$i]} #UUID
	   	  UMNT_L[$i]=$FOUND #Location (lsblk=name)
	   	  UMNT_N[$i]=$(($i)) #number on list
	   	  UMNT_D[$i]=${DESC[$i]} #description
	   	  UMNT_M[$i]='' #is mount point
	   	  UMNT_CL[$i]=$CRYPT_TEST #Location (lsblk=name) but crypt
	   	  UMNT_CM[$i]=$B #is Crypt mount point
	   	  UMNT_CU[$i]=$(grep -w ${B} /etc/fstab | cut -d ' ' -f1 | cut -c 6-) #UUID for crypt drive based on crypt mountpoint from fstab
	     fi
	fi
fi

done

#####  --- WELCOME & LIST --- #####
echo "Welcome to CryptDrive Select!"
echo "displaying currently connected drives..."
sleep 1s
echo "-----"
sudo lsblk -e7 -o NAME,LABEL,MOUNTPOINT,TYPE,uuid,name,SIZE
echo "-----"
echo ""
echo "Please ensure your drive is appropriately listed in fstab and crypttab!"



#####  --- SELECTION --- #####

## -- Option Choice -- ##
while true; do #1
echo "Are you looking to [open], [close], or [remove] a drive?"
read OC #OC is options Open/Close
OC=$(echo "$OC" | awk '{print tolower($0)}')
echo ""
if [ "$OC" == "" ]; then
   echo "Nothing was entered by the user!"
elif [[ "$OC" == "cancel" ]] || [[ "$OC" == "exit" ]]; then
   echo "Canceling..."
   sleep 3s
   exit
elif [[ "$OC" == "open" ]] || [[ "$OC" == "mount" ]] || [[ "$OC" == "decrypt" ]]; then
   echo "Choices for OPEN:"
   for i in ${!MNT_N[@]}; do 
	if [[ "${CRYPT_Y[$i]}" == "0" ]]; then
	   echo "${MNT_N[$i]}) ${MNT_L[$i]}: ${MNT_D[$i]}"
	   DRIVE_U[$i]=${MNT_U[$i]} DRIVE_L[$i]=${MNT_L[$i]} 
	   DRIVE_N[$i]=${MNT_N[$i]} DRIVE_D[$i]=${MNT_D[$i]}
	   DRIVE_M[$i]=${MNT_M[$i]} DRIVE_CL[$i]=${MNT_CL[$i]}
	elif [[ "${CRYPT_Y[$i]}" == "1" ]]; then
	   if [[ "${CMOUNT_Y[$i]}" == "0" ]]; then
	     echo "${MNT_N[$i]}) ${MNT_L[$i]}: ${MNT_CL[$i]}: ${MNT_D[$i]}"
	     DRIVE_U[$i]=${MNT_U[$i]} DRIVE_L[$i]=${MNT_L[$i]} 
	     DRIVE_N[$i]=${MNT_N[$i]} DRIVE_D[$i]=${MNT_D[$i]}
	     DRIVE_M[$i]=${MNT_M[$i]} DRIVE_CL[$i]=${MNT_CL[$i]}
	    else
	     :
	   fi
	else
	   echo "error d1"	 
	fi
   done
   break 1 #1x
elif [[ "$OC" == "close" ]] || [[ "$OC" == "encrypt" ]]; then
   echo "Choices for CLOSE:"   
   for i in ${!UMNT_N[@]}; do 
	if [[ "${CMOUNT_Y[$i]}" == "1" ]]; then
	   echo "${UMNT_N[$i]}) ${UMNT_L[$i]}: ${UMNT_CL[i]}: ${UMNT_D[$i]}"
	   DRIVE_U[$i]=${UMNT_U[$i]} DRIVE_L[$i]=${UMNT_L[$i]} 
	   DRIVE_N[$i]=${UMNT_N[$i]} DRIVE_D[$i]=${UMNT_D[$i]}
	   DRIVE_M[$i]=${UMNT_M[$i]} DRIVE_CL[$i]=${UMNT_CL[$i]}
	   DRIVE_CM[$i]=${UMNT_CM[$i]} DRIVE_CU[$i]=${UMNT_CU[$i]}
	 else
  	   :
	fi
   done   
   break 1 #1x
elif [[ "$OC" == "remove" ]] || [[ "$OC" == "disconnect" ]]; then
   echo "Choices for REMOVE:"
   for i in ${!UMNT_N[@]}; do 
	if [[ "${CRYPT_Y[i]}" == "1" ]]; then
	   if [[ "${CMOUNT_Y[$i]}" == "1" ]]; then
	     echo "${UMNT_N[$i]}) ${UMNT_L[$i]}: ${UMNT_CL[$i]}: ${UMNT_D[$i]}"
	     DRIVE_U[$i]=${UMNT_U[$i]} DRIVE_L[$i]=${UMNT_L[$i]} 
	     DRIVE_N[$i]=${UMNT_N[$i]} DRIVE_D[$i]=${UMNT_D[$i]}
	     DRIVE_M[$i]=${UMNT_M[$i]} DRIVE_CL[$i]=${UMNT_CL[$i]}
	     DRIVE_CM[$i]=${UMNT_CM[$i]} DRIVE_CU[$i]=${UMNT_CU[$i]}
	    else
	     echo "${UMNT_N[$i]}) ${UMNT_L[$i]}: ${UMNT_D[$i]}"
	     DRIVE_U[$i]=${UMNT_U[$i]} DRIVE_L[$i]=${UMNT_L[$i]} 
	     DRIVE_N[$i]=${UMNT_N[$i]} DRIVE_D[$i]=${UMNT_D[$i]}
	     DRIVE_M[$i]=${UMNT_M[$i]} DRIVE_CL[$i]=${UMNT_CL[$i]}
	     DRIVE_CM[$i]=${UMNT_CM[$i]} DRIVE_CU[$i]=${UMNT_CU[$i]}
	   fi
	 else
  	   echo "${UMNT_N[$i]}) ${UMNT_L[$i]}: ${UMNT_D[$i]}"
	   DRIVE_U[$i]=${UMNT_U[$i]} DRIVE_L[$i]=${UMNT_L[$i]} 
	   DRIVE_N[$i]=${UMNT_N[$i]} DRIVE_D[$i]=${UMNT_D[$i]}
	   DRIVE_M[$i]=${UMNT_M[$i]} DRIVE_CL[$i]=${UMNT_CL[$i]}
	   DRIVE_CM[$i]=${UMNT_CM[$i]} DRIVE_CU[$i]=${UMNT_CU[$i]}
	fi	   
   done
   break 1 #1x
else
   : #loop 1
fi
done #1x


## -- Drive Select -- ##
echo ""
echo "----------"
while true; do #2
while true; do #2.1
echo -n "Please select the drive number you would like to $OC"
echo ""
read SEL #SEL is SELECTION: drives numbered according to order in UUID list
if [[ -n ${SEL//[0-9]/} ]]; then
    echo "Please enter ONLY a number!"
elif [ "$SEL" == "" ]; then
    :
else
    #test for valid choice 
    if [[ " ${DRIVE_N[*]} " =~ " ${SEL} " ]]; then
	break #2.1x
    fi
    if [[ ! " ${DRIVE_N[*]} " =~ " ${SEL} " ]]; then
	echo "Must be a valid number from Choices"
    fi
fi
done #2.1x
while true; do #2.2
echo -n "Please confirm that: \"$SEL\" is your choice [y/n]."
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
   break 1 #2.2x
elif [[ "$check" == "confirm" ]] || [[ "$check" == "y" ]] || [[ "$check" == "yes" ]]; then
   break 2 #2x.2x
else
   :
fi
done #2x.2x
done #2x


#####  --- PROGRAM --- #####

## -- Selection Array > Persistant String -- ##
TARGET_CRYPT_Y=${CRYPT_Y[$SEL]} #binary y=1 if in crypttab
TARGET_DMNT_Y=${DMOUNT_Y[$SEL]} #binary y=1 drive has mountpoint
TARGET_CMNT_Y=${CMOUNT_Y[$SEL]} #binary y=1 crypt has mountpoint

TARGET_DU=${DRIVE_U[$SEL]} #UUID
TARGET_DNAME=${DRIVE_L[$SEL]} #Location (lsblk=name)
TARGET_DESC=${DRIVE_D[$SEL]} #Drive Description (from list)
TARGET_DMOUNT=${DRIVE_M[$SEL]} #drive mountpoint
TARGET_CNAME=${DRIVE_CL[$SEL]} #Location (lsblk=name) but crypt
TARGET_CMOUNT=${DRIVE_CM[$SEL]} #crypt mountpoint
TARGET_CU=${DRIVE_CU[$SEL]} #UUID for crypt

<<'debug'
echo "$TARGET_CRYPT_Y"
echo "$TARGET_DMNT_Y"
echo "$TARGET_CMNT_Y"
echo "$TARGET_DU"
echo "$TARGET_DNAME"
echo "$TARGET_DESC"
echo "error hunt"
echo "${MNT_M[$SEL]}"
echo "${UMNT_M[$SEL]}"
echo "${DRIVE_M[$SEL]} Sel=$SEL"
echo "$TARGET_DMOUNT"
echo "end"
echo "$TARGET_CNAME"
echo "$TARGET_CMOUNT"
echo "$TARGET_CU"
echo -n "Press [ENTER] to continue program"
read var_blank
debug


## -- Modes & Outcomes -- ##
if [ "$OC" == "" ]; then
   echo "Error OC #1"
elif [[ "$OC" == "open" ]] || [[ "$OC" == "mount" ]] || [[ "$OC" == "decrypt" ]]; then
    if [[ "$TARGET_CRYPT_Y" == "1" ]]; then
	echo "Running cryptsetup luksOpen \"UUID=$TARGET_DU\" $TARGET_CNAME"
	sudo cryptsetup luksOpen "UUID=$TARGET_DU" $TARGET_CNAME
	TARGET_CU=$(lsblk -e7 -o UUID,name | grep $TARGET_CNAME | awk '{print $1}')
	TARGET_CMOUNT=$(grep -w ${TARGET_CU} /etc/fstab | cut -d ' ' -f2)
	MOUNT=$TARGET_CMOUNT
      else
	TARGET_DMOUNT=$(grep -w ${TARGET_DU} /etc/fstab | cut -d ' ' -f2)
	MOUNT=$TARGET_DMOUNT
    fi
    
    echo "Mounting $MOUNT"
    sudo mount $MOUNT
elif [[ "$OC" == "close" ]] || [[ "$OC" == "encrypt" ]]; then
    if [[ "$TARGET_CRYPT_Y" == "1" ]]; then
	echo "Unmounting $TARGET_CMOUNT"
	sudo umount $TARGET_CMOUNT
	echo "Running cryptsetup luksClose $TARGET_CNAME"
	sudo cryptsetup luksClose $TARGET_CNAME
      else  
	echo "error operation c1"
	sleep 3s
	exit
    fi
elif [[ "$OC" == "remove" ]] || [[ "$OC" == "disconnect" ]]; then
    if [[ "$TARGET_CRYPT_Y" == "1" ]]; then
	echo "Unmounting $TARGET_CMOUNT"
	sudo umount $TARGET_CMOUNT
	echo "Running cryptsetup luksClose $TARGET_CNAME"
	sudo cryptsetup luksClose $TARGET_CNAME
	echo "Failsafe non-crypt unmount on: $TARGET_DMOUNT (likely to fail)."
	sudo umount $TARGET_DMOUNT
      elif [[ "$TARGET_CRYPT_Y" == "0" ]]; then
	echo "Unmounting $TARGET_DMOUNT"
	sudo umount $TARGET_DMOUNT
      else
      	echo "error operation r0"
      	sleep 3s
      	exit
    fi
    DRIVE=$(sudo blkid | grep UUID=\"$TARGET_DU\")
    TARGET_DISK="${DRIVE:0:8}"
    sleep 2s
    echo "Ejecting $TARGET_DISK with SCSI commands"
    sudo eject -sv $TARGET_DISK
    sleep 2s
    echo ""
    echo "Ejecting $TARGET_DISK with all commands"
    sudo eject -v $TARGET_DISK
    sleep 5s
    echo ""
    echo "Attempting power-off $TARGET_DISK"
    sudo udisksctl power-off -b $TARGET_DISK
    echo ""
    echo "Review Output"
else 
        echo "error operation r1"
        sleep 3s
        exit
fi

## -- Finishing Display -- ##
echo "-----"
sudo lsblk -e7 -o NAME,LABEL,MOUNTPOINT,TYPE,uuid,name,SIZE
echo "-----"
echo ""
echo -n "Press [ENTER] to end program"
read var_blank
exit

#Version_1.00
#Version_Code.MinorChanges

#Change Log:

#1.00: Initial Release of all textbased solution (see crypt1-3 for past iterations)
