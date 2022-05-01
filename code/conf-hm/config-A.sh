#!/bin/bash

#Config file for folder choices A. Used for unique or complex folders.

#  --- OPTIONS  --- #
#!!!!!! Check your Choices & Program Settings if you change these!!!!!!!

#list A. (non name specific names just no Circumflex)
FldA=(
	"Root" 
	"Home Hidden Folders" 
	"Home Visible Files" 
	"Games")
 
LstA=(
	1 "\"${FldA[0]}\"" off #0
	2 "\"${FldA[1]}\"" off #3
	3 "\"${FldA[2]}\"" off #6
	4 "\"${FldA[3]}\"" off #9
	)
	
#To change displayed options for program 1 (rsync), add or remove corresponding multiple of three from LstA
KpAR=("3" "6" "9")
