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
Sp0=" " #formerly 3
Sp1=' "' #text needed to make dialog's options work in conjoining the text
Sp2='" off '
Sp3="_" #formerly 4
Sp4="*"
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
Prog00="dialog.sh"
Prog01=""

#program choice
PG01="rsync"
PG02="tar"
PG03="both - same folders"
PG04="BOTH - different folders"

#meta
PRGNM="BBB"
Ver="0.0x.01"

