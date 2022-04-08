#!/bin/bash

##### --- DIALOG PROGRAM --- #####

####  --- INTRO --- #### 

# Define the dialog exit status codes
: ${DIALOG_OK=0}
: ${DIALOG_CANCEL=1}
: ${DIALOG_HELP=2}
: ${DIALOG_EXTRA=3}
: ${DIALOG_ITEM_HELP=4}
: ${DIALOG_ESC=255}
 

### -- Dialog 1 -- ###
# - Verify Location - #
dialog --yes-label "Continue" --no-label "Cancel" --title "Backup Intro 1" --yesno  "This is: $PRGNM version $Ver \n 
This program will create a backup copy of your files. \n
You will be provided with choices for compression or not.\n \n
WARNING! Please be sure the following is the desired output location.\n \n
File location: \n
$cwd" 22 76 
return_value=$? # Get dialog's exit status
case $return_value in # Act on the exit status
  $DIALOG_OK) ;;
  $DIALOG_CANCEL)
  	clear
	echo "Canceled on Source Check 1" | tee -a "$log" | tee -a "$debug"
	exit
	;;
esac


### -- Dialog 2 -- ###
# - Verify Name - #
while true; do #1 Name (final Redo)
while true; do #1.1 Name choice confirm
#turing user name check
dialog --extra-button --extra-label "Change" --title "Backup Intro 2" --yesno  "Is the following the correct user name for back up: \n
$N" 30 76 
return_value=$? # Get dialog's exit status
case $return_value in # Act on the exit status
  $DIALOG_OK) 
  	break ;;
  $DIALOG_CANCEL)
  	clear
	echo "Canceled on Source Check 2a" | tee -a "$log" | tee -a "$debug"
	exit
	;;
  $DIALOG_EXTRA)
  	TmpUser="tmpUser.txt" #specifcy temp file for user name
  	dialog --clear --title "Backup User Correction" --inputbox "Please enter the correct user name or press cancel to exit." 30 76 2>$TmpUser
	return_value2=$? # Get dialog's exit status
	case $return_value2 in # Act on the exit status
		$DIALOG_OK) 
		N=$(<$TmpUser) #this writes the temp file to N
		rm $TmpUser #remove tempfile
		echo "User Changed to: $N" | tee -a "$log" >> "$debug"
		echo "" | tee -a "$log" >> "$debug"
		;;
		$DIALOG_CANCEL)
		clear
		echo "Canceled on Source Check 2b" | tee -a "$log" | tee -a "$debug"
		rm $TmpUser #clear temp file on cancel
		exit
		;;
	esac
esac
done #1.1x Name choice confirm



####  --- PROGRAMS & FOLDERS --- #### 
### -- Dialog 3 -- ###
# - Program choice - #
while true; do #1.2 #Prog (final Redo)
RS_Options="$RSYNC_OPTIONS"
while true; do #1.2.1 	Creation of Var after coice
while true; do #1.2.1.1 Choice Loop (must choose or redo)
#Choice of program 1
PgOpt=(
	1 "$PG01" off 
	2 "$PG02" off
	3 "$PG03" off
	4 "$PG04" off
	)
Pg=$(dialog --title "Backup Program Select" --radiolist "Select a backup program:" 30 76 20 "${PgOpt[@]}" 2>&1 >/dev/tty)
return_value=$?
case $return_value in
 	$DIALOG_CANCEL)
  	   dialog --title "Backup Canceled" --msgbox "Backup was canceled at your request." 30 76
  	   clear
  	   echo "Canceled on Program Select" | tee -a "$log" >> "$debug"
  	   exit ;;
	$DIALOG_OK) 
  	   : ;;
esac
if [ -z "$Pg" ]; then
  dialog --ok-label "Redo" --title "No Program Selected" --msgbox "You must select a program." 30 76
else
break #1.2.1.1x
fi
done #1.2.1.1x

#interpret choice
case $Pg in
   1)
       PgD="$Pg $PG01"
       OptRS=1 #binay 0=no 1=yes for choice of rsync
       OptTar=0 #y/n for tar
       Lp=1 #number of times through folder options loop
       ;;
   2)
       PgD="$Pg $PG02"
       OptRS=0
       OptTar=1
       Lp=1  
       ;;
   3)
       PgD="$Pg $PG03"
       OptRS=1
       OptTar=1
       Lp=1  
       ;;
   4)
       PgD="$Pg $PG04"
       OptRS=1
       OptTar=1
       Lp=2
       ;;
esac


# - Rsync options - #
#Check if even running RS 
if [ "$OptRS" -eq "$O" ]; then #1.2.1.2a
	while true; do #1.2.1.2a.1
	dialog --cancel-label "No" --ok-label "Yes" --extra-button --extra-label "Change" --title "Rsync Options Choice" --yesno "Would you like to turn on the following rsync options: \n
	\"$RS_Options\"" 30 76 
	return_value=$? # Get dialog's exit status
	case $return_value in # Act on the exit status
	  $DIALOG_OK) 
	  	RSoptDialog="rsync \"$RS_Options\" option(s): ON."
	  	RS_Opt_ON=1
	  	break ;; #1.2.1.2a.1x
	  $DIALOG_CANCEL)
	  	RSoptDialog="rsync option(s): OFF."
	  	RS_Opt_ON=0
	  	break ;; #1.2.1.2a.1x
	  $DIALOG_EXTRA)
	  	TmpRS="tmpRS.txt" #specifcy temp file for RS_Options
	  	dialog --title "Rsync Options Set" --inputbox "Please enter desired options ending with a space" 30 76 2>$TmpRS
		return_value2=$? # Get dialog's exit status
		case $return_value2 in # Act on the exit status
			$DIALOG_OK) 
			RS_Options=$(<$TmpRS) #this writes the temp file to variable
			rm $TmpRS #remove tempfile
			: ;; #repeats 1.2.1.2a
			$DIALOG_CANCEL)
			clear
			rm $TmpRS #clear temp file on cancel
			echo "Canceled on RS Options" | tee -a "$log" | tee -a "$debug"
			exit ;;
		esac
	esac
	done #1.2.1.2a.1x
   else #1.2.1.2b
	echo "" | tee -a "$log" >> "$debug"
	RSoptDialog="Option(s): OFF."
   	RS_Opt_ON=0
fi #1.2.1.2x

# - Display Program Choices - #
dialog --extra-button --extra-label "Redo" --yes-label "Continue" --no-label "Cancel" --title "Backup Program Choice" --yesno  "You have selected to run the following: \n
$PgD \n
$RSoptDialog \n \n
You will be provided with folder choices next." 30 76 
return_value=$? # Get dialog's exit status
case $return_value in # Act on the exit status
  $DIALOG_OK) 
  	break ;; #1.2.1x
  $DIALOG_EXTRA)
  	: ;; #repeats loop 1.2.1
  $DIALOG_CANCEL)
  	echo "Canceled on Program Choice Confirm" | tee -a "$log" | tee -a "$debug"
	exit ;;
esac
done #1.2.1x
#confirm options
if [ "$RS_Opt_ON" -eq "$Z" ]; then 
	RS_Options=""
   else
   	: 
fi

echo "Program Choice: $PgD"  | tee -a "$log" >> "$debug"
echo "RS: $OptRS:$RS_Opt_ON ; Tar: $OptTar." | tee -a "$log" >> "$debug"
echo "RS Options: \"$RS_Options\"" | tee -a "$log" >> "$debug"
echo "Number of loops: $Lp" >> "$debug"
echo "---" | tee -a "$log" >> "$debug"
echo "" | tee -a "$log" >> "$debug"



### -- Dialog 4 -- ####
#Folder Options

# - Display check skip - #
while true; do #1.2.2  Folder (final Redo)

# - Start Options Loop - #
for i in $(seq $Lp); do #1.2.2.1
echo "# Loop number: $i Out of: $Lp" >> "$debug"
LstA=() LstAT=() LstAR=() KpAR=() FldA=() OptA=() ChA=()
FldB=() NumB=() LstB=() ChB=() #clear any existing (useful for loop)
source ./code/conf-hm/config-A.sh
for x in ${!KpAR[@]}; do
   LstAR+=("${LstA[@]:${KpAR[$x]}:3}")  #add only selected in KpAR to LstAR
done
LstAT=("${LstA[@]}") #make LstA -> AT as new tar list
LstA=()


# - Pull Options - #
#Options A
#check what program and loop interation
if [ "$OptRS" -eq "$O" ]; then
    if [ "$Lp" -eq "$T" ]; then
	if [ "$i" -eq "$T" ]; then
		
		echo "Pull config ATR - 122" >> "$debug"
		LstA=("${LstAT[@]}") 
		OPTION_TXT="For tar:"
		OutA2=()
		OutB2=()
	else
		echo "Pull config ARS - 121" >> "$debug"
		LstA=("${LstAR[@]}")
		OPTION_TXT="For rsync:"
	fi	
    else
	echo "Pull config ARS - 11x" >> "$debug"
	LstA=("${LstAR[@]}")
	OPTION_TXT=""
    fi
else
    echo "Pull config ATR - 0xx" >> "$debug"
    LstA=("${LstAT[@]}")
    OPTION_TXT=""
fi
echo "" >> "$debug"


#Options B
#get Options
source ./code/conf-hm/config-B.sh

#setup
NumB=($(seq 1 1 ${#FldB[@]})) #make an array with 1 through exact number of item in Fld
  for ib in ${!NumB[@]}; do #joins numbers and folders into text for options list
	LstB+=${NumB[$ib]}$Sp1${FldB[$ib]}$Sp2
  done


# - Options Dialogs - #
#Start of Dialog A
ChA=$(dialog --title "Backup Options A" --checklist "Select folder options A: \n $OPTION_TXT" 30 76 20 "${LstA[@]}" 2>&1 >/dev/tty)
return_value=$?
if [ "$return_value" != "0" ]
then
  dialog --title "Backup Canceled" --msgbox "Backup was canceled at your request." 30 76
  clear
  echo "Canceled on Options A" | tee -a "$log" >> "$debug"
  exit
else
echo ""
fi

#Start of Dialog B
ChB=$(dialog --title "Backup Options B" --checklist "Select folder options B: \n $OPTION_TXT" 30 76 20 $LstB 2>&1 >/dev/tty)
return_value=$?
if [ "$return_value" != "0" ]
then
  dialog --title "Backup Canceled" --msgbox "Backup was canceled at your request." 30 76
  clear
  echo "Canceled on Options B" | tee -a "$log" >> "$debug"
  exit
else
echo ""
fi


#Write choices out
if [ "$i" -eq "$T" ]; then
	OutA2=$ChA
	OutB2=$ChB
   else
	OutA1=$ChA
	OutB1=$ChB
	OutA2=$ChA
	OutB2=$ChB
fi
done #1.2.2.1 done for options loop



# - Display Choices - #
 
#Variable Maker Loop
for x in {0..3};do #1.2.2.2 #Run 4 times (once per input/output)
   for x in $x; do #1.2.2.2.1 #Get Variables for the round
   #clean up before loop
OUT=() FLD=() PRINT=() TRASH=() Var1=() Var2=() Var3=() Var4=() Var5=()
	case $x in
		0) 
		   OUT=$OutA1
		   FLD=("${FldA[@]}") ;;
		1) 
		   OUT=$OutB1
		   FLD=("${FldB[@]}") ;;
		2)
		   OUT=$OutA2
		   FLD=("${FldA[@]}") ;;
		3) 
		   OUT=$OutB2
		   FLD=("${FldB[@]}") ;;
	esac
   done #1.2.2.2.1

#Part 1: Make Printable List w/ numbers
IFS=$Sp0 read -ra Var1 <<< "${OUT[@]}"  #break choice #s into seperate array items
   for r1 in ${!Var1[@]}; do  #conjoin choice #s w/ folder. String seperated by Sp3
	Var2+=${Var1[$r1]}$Sp0${FLD[${Var1[$r1]}-1]}$Sp5
   done
IFS=$Sp5 read -ra Var3 <<< "${Var2[@]}" #break string into seperate array items by Sp3
#Var3="Number Folder" per item
PRINT=$(printf "'%s'\n" "${Var3[@]}") #print array items on new lines for display

#Part 2: Make Printable List w/o numbers
   for i3 in ${!Var1[@]}; do
	Var4+=${FLD[${Var1[$i3]}-1]}$Sp5 #Var4="Folder^" in continuous string by Sp5
   done
IFS=$Sp5 read -ra Var5 <<< "${Var4[@]}" #break string into seperate array items by Sp5
#Var5="Folder" per line

   for x in $x; do #1.2.2.2.2 #Output for each round
	case $x in
		0) 
		   TRASH=("${Var5[@]}")
		   PRINTA1=("${PRINT[@]}") ;;
	   	1) 
		   CFB1=("${Var5[@]}")
	   	   PRINTB1=("${PRINT[@]}") ;;
		2)
		   TRASH=("${Var5[@]}")
		   PRINTA2=("${PRINT[@]}") ;;
		3) 
		   CFB2=("${Var5[@]}")
		   PRINTB2=("${PRINT[@]}") ;;
	esac
   done #1.2.2.2.2
done #1.2.2.2


#Actuall Display them
while true; do #1.2.2.3 #Just review choices
dialog --extra-button --extra-label "Redo" --yes-label "Continue" --no-label "Cancel" --title "Confirm Folder Options" --yesno  "Does the following look correct: \n \n
Programs Selected: \n
$PgD \n
$RSoptDialog \n \n
Folders for rsync (if applicable) \n
$PRINTA1 \n
$PRINTB1 \n \n
Folders for tar (if applicable) \n
$PRINTA2 \n
$PRINTB2 \n \n \n \n
Confirm or press [Redo] to try again." 30 76 
return_value=$? # Get dialog's exit status
case $return_value in # Act on the exit status
  $DIALOG_OK)
  break 4 #1x.2x.2x.3x
  ;;
  $DIALOG_CANCEL)
  clear
  echo "Canceled on Confirmation 1" >> "$debug"
  exit
  ;;
  $DIALOG_EXTRA)
  	while true; do #1.2.2.3.1
  	REDO_CH=()
  	REDO_OPTIONS=(
	   1 "Folders" off 
	   2 "Programs and Folders" off
	   3 "Name, Programs, and Folders" off
	   4 "Review Choices Again" on
	   )
	REDO_CH=$(dialog --title "Redo Select" --radiolist "Select how much to Redo:" 30 76 20 "${REDO_OPTIONS[@]}" 2>&1 >/dev/tty)
	return_value2=$?
		case $return_value2 in
 			$DIALOG_CANCEL)
		  	   dialog --title "Backup Canceled" --msgbox "Backup was canceled at your request." 30 76
		  	   clear
		  	   echo "Canceled on Redo Select" | tee -a "$log" >> "$debug"
		  	   exit ;;
			$DIALOG_OK) 
		  	   : ;; #continue to choice
		esac
	if [ -z "$REDO_CH" ]; then
	   dialog --ok-label "REDO" --title "No Redo Selected" --msgbox "You must select an option." 30 76
	else
	   case $REDO_CH in
	   	1)
	   	f_COUNT=$(($f_COUNT + $O))
	   	echo "---" >> "$debug"
	   	echo "Folder Options Reset: $f_COUNT" >> "$debug"
	   	break 2 #1.2.2.3x.1x
	   	;;
	   	2)
	   	p_COUNT=$(($f_COUNT + $O))
	   	echo "---" >> "$debug"
	   	echo "Program Options Reset: $p_COUNT" >> "$debug"
	   	break 3 #1.2.2x.3x.1x
	   	;;
	   	3)
	   	n_COUNT=$(($f_COUNT + $O))
	   	echo "---" >> "$debug"
	   	echo "Name Options Reset: $p_COUNT" >> "$debug"
	   	break 4 #1.2x.2x.3x.1x
	   	;;
	   	4)
	   	#review again option
	   	break 1 #1.2.2.3.1x
	   	;;
	   esac
	fi
	done #1.2.2.3.1x	
esac
done #1.2.2.3x #Choice Review
done #1.2.2x #Name, Program, Folders
done #1.2x #Name, Program
done #1x  #Name

#debug and results for logs
echo "#########################" | tee -a "$log" >> "$debug"
echo "rsync choices A1:" | tee -a "$log" >> "$debug"
echo "$PRINTA1" | tee -a "$log" >> "$debug"
echo "_________________________" | tee -a "$log" >> "$debug"
echo "rsync choices B1:" | tee -a "$log" >> "$debug"
echo "$PRINTB1" | tee -a "$log" >> "$debug"
echo "_________________________" | tee -a "$log" >> "$debug"
echo "tar choices A2:" | tee -a "$log" >> "$debug"
echo "$PRINTA2" | tee -a "$log" >> "$debug"
echo "_________________________" | tee -a "$log" >> "$debug"
echo "tar choices B2:" | tee -a "$log" >> "$debug"
echo "$PRINTB2" | tee -a "$log" >> "$debug"
echo "_________________________" | tee -a "$log" >> "$debug"
echo "" | tee -a "$log" >> "$debug"
echo "" | tee -a "$log" >> "$debug"

#final confirmation
dialog --title "Final Confirmation" --yesno  "\n \n \n \n
Are you ready to begin? \n \n
You may check the log file if you need to double check. \n
Canceling here will end the progam \n \n
Press [Yes] to begin or press [No] to exit." 30 76 
return_value=$? # Get dialog's exit status
case $return_value in # Act on the exit status
  $DIALOG_OK)
  ;;
  $DIALOG_CANCEL)
  clear
  echo "Final Confirmation Cancelation" | tee -a "$log" | tee -a "$debug"
  exit
  ;;
esac

#### --- PROGRAMS --- ####
#Grab in Prep for programs using A options
source ./code/conf-hm/config-HID.sh
source ./code/conf-hm/config-GM.sh

clear #So you can see the text on the screen
echo "#########################" | tee -a "$log" | tee -a "$debug"
echo " -- Main Programs -- " | tee -a "$log" | tee -a "$debug"

#options
if [ "$OptRS" -eq "$O" ]; then
	echo "" | tee -a "$log" | tee -a "$debug"
	echo "Starting rsync..."
	printf "Start rsync - $(date)" | tee -a "$log" >> "$debug"
	echo "" | tee -a "$log" | tee -a "$debug"
	source ./code/prog-hm/rsync.sh
	printf "Completed rsync - $(date)" | tee -a "$log" >> "$debug"
	echo "" | tee -a "$log" | tee -a "$debug"
  elif [ "$OptRS" -eq "$Z" ]; then
  	echo ""
  else
  	echo "No program selected - see debug log" | tee -a "$log" | tee -a "$debug"
fi
PATHIN=() PATHOUT=() INPUT=() OUTPUT=() #clear between programs

echo "" | tee -a "$log" >> "$debug"
echo "" | tee -a "$log" >> "$debug"
echo "__________________________" | tee -a "$log" >> "$debug"
echo "" | tee -a "$log" >> "$debug"
echo "" | tee -a "$log" >> "$debug"
if [ "$OptTar" -eq "$O" ]; then
	echo "" | tee -a "$log" | tee -a "$debug"
	echo "Starting tar..." | tee -a "$log" | tee -a "$debug"
	printf "Start tar - $(date)" | tee -a "$log" >> "$debug"
	echo "" | tee -a "$log" | tee -a "$debug"
	source ./code/prog-hm/tar.sh
	printf "Completed tar - $(date)" | tee -a "$log" >> "$debug"
	echo "" | tee -a "$log" | tee -a "$debug"
  elif [ "$OptTar" -eq "$Z" ]; then
  	echo ""
  else
  	echo "No program selected - see debug log" | tee -a "$log" | tee -a "$debug"
fi


#Version_1.00
#Version_Code.MinorChanges

#Change Log:
#5.00: Simplified variables. Cleaned dialog loops 1-3. Added write-in option for rsync settings. Added extra "Redo" label and allowed for Cancel. 
#4.00: Simplified FldA & FldB; added unified config-A w/ easier item removal for RS
#3.00: Added loop for variable maker. Added better loop numbering. Cleaners up layout.
#2.00: Shortened due to new directory structure & master.sh 
#1.01: Fixed log & debug output for tar choices.
#1.00: Version Original version
