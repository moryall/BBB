#!/bin/bash

#Config file for common abreviations used in my Backup programs.

#  --- FILE SETUP --- #
#constants
Z=0
O=1
T=2
#variables with starting value
c=0

#shorts
SL="/"
Sp0=" " #Blank Space
Sp1=' "' #dialog's option spacer
Sp2='" off ' #dialog's option spacer
Sp3="_" #used many places, especially file names
Sp4="*" #used when wildcard is needed
Sp5="^" #used as a spacer in variable split/joiner
#extensions
Ext1=".txt"
Ext2=".tgz"
#words
Wd1="Backup"
Wd2="Log"
Wd3="Debug"
Wd4="tmp"
Wd5="rsync" #word used for name of rsync folder
Wd6="tar" #word used for name of tar folder
#folders
FL0="/home/"
FL1="logs"
FL2="temp"
FL3="code"

#programs
Prog00="master.sh"
Prog01="dialog.sh"

#program choice
PG01="rsync"
PG02="tar"
PG03="both - same folders"
PG04="BOTH - different folders"

#meta
PRGNM="BBB"
Ver="x2.00.00-01"
