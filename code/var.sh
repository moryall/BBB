#!/bin/bash

#Config file for common abreviations used in my Backup programs.

#  --- FILE SETUP --- #
#variables with starting value
f_COUNT=0 #counter for repeats of folder select loops
p_COUNT=0 #counter for repeats of program and folders loops
n_COUNT=0 #counter for repeats of name, program, folder loops

#words
Wd1="Backup" #Used to make tar files
Wd2="Log" #Used to make log location/file
Wd3="Debug" #Used to make debug location/file
Wd4="tmp" #Used to make location/file
Wd5="rsync" #word used for name of rsync folder
Wd6="tar" #word used for name of tar folder

#folders
FL0="home" #"/home/"
FL1="logs"
FL2="temp"
FL3="code"

#programs
Prog00="master.sh"
Prog01="dialog.sh"

#program choice - used to display names of options in dialog 3.
PG01="rsync"
PG02="tar"
PG03="both - same folders"
PG04="BOTH - different folders"

#program default option (must end with a space!
RSYNC_OPTIONS="--delete "

#meta
PRGNM="BBB"
Ver="x2.00.00-03"
