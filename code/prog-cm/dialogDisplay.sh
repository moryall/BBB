#!/bin/bash

#usage 1:   ./dialogDisplay.sh [start|stop] <define setting file loc till/>
#usage 2: DISPLAY_PRESET=[start|stop] && source ./dialogDisplay.sh (within prog-cm)
#settings
DISPLAY_FILE=dialogrc-purple

#setup
if [ "$EUID" -ne 0 ]
  then echo "Error 0 dialogDisplay:"
  echo "Please run as root"
  exit
else #the rest

#check if com is loaded, if so use predetermined variable from other script
if [ "$DISPLAY_PRESET" == "" ]; then
	if [[ -z $2 ]]; then
	   DISPLAY_SETTING=$1
	   DISPLAY_FILE="./$DISPLAY_FILE"
	else
	   DISPLAY_SETTING=$1
	   DISP_LOC=$2
	   DISPLAY_FILE="$DISP_LOC$DISPLAY_FILE"
	fi
else
	DISPLAY_SETTING=$DISPLAY_PRESET
	DISPLAY_FILE="$srcd/code/prog-cm/$DISPLAY_FILE"
fi


#do the thing
while true; do #1
DISPLAY_SETTING=$(echo "$DISPLAY_SETTING" | awk '{print tolower($0)}')

if [ "$DISPLAY_SETTING" == "" ]; then
   echo "Error 1 dialogDisplay:"
   echo "please select dialog color [start] or [stop]."
   read DISPLAY_SETTING
   : #loop 1
elif [[ "$DISPLAY_SETTING" == "start" ]]; then
   if [ ! -f /etc/dialogrc ]; then
	cp $DISPLAY_FILE /etc/dialogrc
   else
	mv /etc/dialogrc /etc/dialogrc__TEMPBKUP__
	cp $DISPLAY_FILE /etc/dialogrc
   fi
   break 1 #1x
elif [[ "$DISPLAY_SETTING" == "stop" ]]; then
   if [ ! -f /etc/dialogrc__TEMPBKUP__ ]; then
	rm /etc/dialogrc
   else
	rm /etc/dialogrc
	mv /etc/dialogrc__TEMPBKUP__ /etc/dialogrc
   fi
   break 1 #1x
else
   echo "Error 2 dialogDisplay"
   echo "Setting error"
   exit
fi
done #1x
fi #end of sudo check

#Version_1.00
#Version_Code.MinorChanges

#Change Log:
#1.00: Created
