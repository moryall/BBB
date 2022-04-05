#!/bin/bash

# --- DIALOG PROGRAM --- #

# Define the dialog exit status codes
: ${DIALOG_OK=0}
: ${DIALOG_CANCEL=1}
: ${DIALOG_HELP=2}
: ${DIALOG_EXTRA=3}
: ${DIALOG_ITEM_HELP=4}
: ${DIALOG_ESC=255}
 
 
#  -- INTRO -- # 
# - Dialog 1 - #
#turing location check
dialog --yes-label "Continue" --no-label "Cancel" --title "Backup Intro 1" --yesno  "This is: $PRGNM version $Ver\n
This program will create a backup copy of your files. \n
You will be provided with choices for compression or not.\n
\n
WARNING! Please be sure the following is the desired output location.\n
\n
File location: \n
$cwd" 22 76 
return_value=$? # Get dialog's exit status
case $return_value in # Act on the exit status
  $DIALOG_OK) ;;
  $DIALOG_CANCEL)
  	clear
	echo "Canceled on Source Check 1" | tee -a "$log" | tee -a "$debug"
	sleep 2s 
	exit
	;;
esac




# - Dialog 2 - #

# - Name Choice - #
while true; do #1
#turing user name check
dialog --no-label "Change" --title "Backup Intro 2" --yesno  "Is the following the correct user name for back up: \n
$N" 30 76 
return_value=$? # Get dialog's exit status
case $return_value in # Act on the exit status
  $DIALOG_OK) 
  	break
  	;;
  $DIALOG_CANCEL)
  	TmpUser="tmpUser.txt" #specifcy temp file
  	dialog --clear --title "Backup User Correction" --inputbox "Please enter the correct user name or press cancel to exit." 30 76 2>$TmpUser
	sub1=$? # Get dialog's exit status
	case $sub1 in # Act on the exit status
		$DIALOG_OK) 
		N=$(<$TmpUser) #this writes the temp file to N
		rm $TmpUser #remove tempfile
		echo "User Changed to: $N" | tee -a "$log" >> "$debug"
		echo "" | tee -a "$log" >> "$debug"
		;;
		$DIALOG_CANCEL)
		clear
		echo "Canceled on Source Check 2" | tee -a "$log" | tee -a "$debug"
		rm $TmpUser #clear temp file on cancel
		exit
		;;
	esac
esac
done #1 Name choice confirm while loop ends here







# - Dialog 3 - #
# - Program Choice - #
while true; do #2
while true; do #2.1
#Choice of program
cmd=(dialog --title "Backup Program Select" --radiolist "Select a backup program:" 30 76 20)
Pg=(
	1 "$PG01" off 
	2 "$PG02" off
	3 "$PG03" off
	4 "$PG04" off
	)
Pg=$("${cmd[@]}" "${Pg[@]}" 2>&1 >/dev/tty)
if [ "$?" != "0" ]; then
  dialog --title "Backup Canceled" --msgbox "Backup was canceled at your request." 30 76
  clear
  echo "Canceled on Program Select" | tee -a "$log" >> "$debug"
  exit
else
echo ""
fi
if [ -z "$Pg" ]; then
  dialog --ok-label "Redo" --title "No Program Selected" --msgbox "You must select a program." 30 76
else
break #2.1x
fi
done #2.1
Pg1=$Pg

#interpret choice
for Pg1 in $Pg1; do #2.2
    case $Pg1 in
        1)
            PgD="$Pg1 $PG01"
            OptRS=1 #binay 0=no 1=yes for choice of rsync
            OptTar=0 #y/n for tar
            Lp=1 #number of times through folder options loop
            ;;
        2)
            PgD="$Pg1 $PG02"
            OptRS=0
            OptTar=1
            Lp=1  
            ;;
        3)
            PgD="$Pg1 $PG03"
            OptRS=1
            OptTar=1
            Lp=1  
            ;;
        4)
            PgD="$Pg1 $PG04"
            OptRS=1
            OptTar=1
            Lp=2
            ;;
    esac
done #2.2

#Chose if RS to use --delete tag added
if [ "$OptRS" -eq "$O" ]; then
	dialog --title "Rsync Option" --yesno "Would you like to turn on --delete" 30 76 
	return_value=$? # Get dialog's exit status
	case $return_value in # Act on the exit status
	  $DIALOG_OK) 
	  	extra="--delete "
	  	RSoptDialog="rsync --delete option is on."
	  	;;
	  $DIALOG_CANCEL)
	  	extra=""
	  	RSoptDialog="rsync --delete option is off."
		;;
	esac
else
   	echo ""
   	extra=""
   	RSoptDialog=""
fi	
cmd=""

#display choice
dialog --yes-label "Continue" --no-label "Redo" --title "Backup Program Choice" --yesno  "You have selected to run the following:\n
$PgD \n
$RSoptDialog \n
\n
You will be provided with options next." 30 76 
return_value=$? # Get dialog's exit status
case $return_value in # Act on the exit status
  $DIALOG_OK) 
  	break #break 2
  	;;
  $DIALOG_CANCEL)
  	:
  	;;
esac
cmd=""
done #end off choice loop 2

echo "Program Choice: $PgD"  | tee -a "$log" >> "$debug"
echo "RS: $OptRS; Extra: $extra.  Tar: $OptTar." | tee -a "$log" >> "$debug"
echo "Number of loops: $Lp" >> "$debug"
echo "---" | tee -a "$log" >> "$debug"
echo "" | tee -a "$log" >> "$debug"




# -- OPTIONS LOOPS -- #

# - Display check skip - #
while true; do #3

# - Start Options Loop - #
for i in $(seq $Lp); do #3.1
echo "# Loop number: $i Out of: $Lp" >> "$debug"

# - Pull Options - #
#Options A
#clear any existing (useful for loop)
FldA=() NumA=() OptA=() LstA=() LstAx=() ChA=() 

#check what program and loop interation
if [ "$OptTar" -eq "$O" ]; then
    if [ "$Lp" -eq "$T" ]; then
	if [ "$i" -eq "$T" ]; then
		
		echo "Pull config ATR - 122" >> "$debug"
		source ./code/conf-hm/config-ATR.sh
		Alpha="For tar:"
		OutA2=()
		OutB2=()
	else
		echo "Pull config ARS - 121" >> "$debug"
		source ./code/conf-hm/config-ARS.sh
		Alpha="For rsync:"
	fi	
    else
	echo "Pull config ARS - 11x" >> "$debug"
	source ./code/conf-hm/config-ARS.sh
	Alpha=""
    fi
else
    echo "Pull config ARS - 0xx" >> "$debug"
    source ./code/conf-hm/config-ARS.sh
    Alpha=""
fi
echo "" >> "$debug"
NumA=($(seq 1 1 ${#AN00[@]})) #make an array with 1 through exact number of item
  for NA1 in ${!NumA[@]}; do #joins numbers and folders into text for options list
	LstAx+=${NumA[$NA1]}$Sp0${AN00[$NA1]}$Sp3 #Ax for keeping A clear. 
  done
OptA=("${LstA[@]}")

<<'FINDBUG'
echo "Folder A Options:" >> "$debug"
echo "${LstAx[@]}" >> "$debug"
echo "Folder A Available:" >> "$debug"
echo "${LstA[@]}" >> "$debug"
echo "" >> "$debug"
FINDBUG

#Options B
#clear any existing (useful for loop)
FldB=() NumB=() OptB=() LstB=() ChB=()

#get Options
source ./code/conf-hm/config-B.sh

<<'FINDBUG'
echo "Folder B Options:" >> "$debug"
echo "${FldB[@]}" >> "$debug"
echo "" >> "$debug"
echo "" >> "$debug"	
FINDBUG

#setup
NumB=($(seq 1 1 ${#FldB[@]})) #make an array with 1 through exact number of item in Fld
  for ib in ${!NumB[@]}; do #joins numbers and folders into text for options list
	LstB+=${NumB[$ib]}$Sp1${FldB[$ib]}$Sp2
  done


# - Options Dialogs - #
cmd=""
#Start of Dialog A
cmd=(dialog --title "Backup Options A" --checklist "Select folder options A: \n $Alpha" 30 76 20)
ChA=$("${cmd[@]}" "${OptA[@]}" 2>&1 >/dev/tty)
if [ "$?" != "0" ]
then
  dialog --title "Backup Canceled" --msgbox "Backup was canceled at your request." 30 76
  clear
  echo "Canceled on Options A" | tee -a "$log" >> "$debug"
  exit
else
echo ""
fi
cmd=""

#Start of Dialog B
cmd=(dialog --title "Backup Options B" --checklist "Select folder options B: \n $Alpha" 30 76 20) #--separate-output was taken out
OptB=(${LstB[@]})
ChB=$("${cmd[@]}" "${OptB[@]}" 2>&1 >/dev/tty)
if [ "$?" != "0" ]
then
  dialog --title "Backup Canceled" --msgbox "Backup was canceled at your request." 30 76
  clear
  echo "Canceled on Options B" | tee -a "$log" >> "$debug"
  exit
else
echo ""
fi
cmd=""

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
done #3.1 done for options loop



# - Display Choices - #
 
#Variable Maker Loop
for x in {0..3};do #3.2 #Run 4 times (once per input/output)
   for x in $x; do #3.2.1 #Get Variables for the round
	case $x in
		0) 
		   OUT=$OutA1
		   FLD=("${AN00[@]}") ;;
		1) 
		   OUT=$OutB1
		   FLD=("${FldB[@]}") ;;
		2)
		   OUT=$OutA2
		   FLD=("${AN00[@]}") ;;
		3) 
		   OUT=$OutB2
		   FLD=("${FldB[@]}") ;;
	esac
   done #3.2.1

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
	Var4+=${FLD[${Var1[$i3]}-1]}$Sp5 #Var4="Folder_" in continuous string by Sp3
   done
IFS=$Sp5 read -ra Var5 <<< "${Var4[@]}" #break string into seperate array items by Sp3
#Var5="Folder" per line

   for x in $x; do #3.2.2 #Output for each round
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
   done #3.2.2
#clean up before potential next loop
OUT=() FLD=() PRINT=() TRASH=() Var1=() Var2=() Var3=() Var4=() Var5=()
done #3.2


#Actuall Display them
# Define the dialog exit status codes
: ${DIALOG_OK=0}
: ${DIALOG_CANCEL=1}
: ${DIALOG_HELP=2}
: ${DIALOG_EXTRA=3}
: ${DIALOG_ITEM_HELP=4}
: ${DIALOG_ESC=255}
dialog --yes-label "Continue" --no-label "Redo" --title "Confirm Folder Options" --yesno  "Does the following look correct: \n \n
Programs Selected: \n
$PgD \n
$RSoptDialog \n \n
Folders for rsync (if applicable) \n
$PRINTA1 \n
$PRINTB1 \n \n
Folders for tar (if applicable) \n
$PRINTA2 \n
$PRINTB2 \n \n \n \n
Confirm or press [No] to try again." 30 76 
return_value=$? # Get dialog's exit status
case $return_value in # Act on the exit status
  $DIALOG_OK)
  break #this is what triggers end to the display check while loop
  ;;
  $DIALOG_CANCEL)
  c=$(($c + $O))
  echo "---" >> "$debug"
  echo "Folder Options Reset: $c" >> "$debug"
  ;;
esac
#####  display check choice confirm while loop ends here  ######
done #3 this is the end of while loop
cmd=""

# Define the dialog exit status codes
: ${DIALOG_OK=0}
: ${DIALOG_CANCEL=1}
: ${DIALOG_HELP=2}
: ${DIALOG_EXTRA=3}
: ${DIALOG_ITEM_HELP=4}
: ${DIALOG_ESC=255}
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
cmd=""

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



# --- PROGRAMS --- #
#Grab Hiddens in Prep for programs
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
PATHIN=() PATHOUT=() #clear between programs

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
#3.00: Added loop for variable maker. Added better loop numbering. Cleaners up layout.
#2.00: Shortened due to new directory structure & master.sh 
#1.01: Fixed log & debug output for tar choices.
#1.00: Version Original version
