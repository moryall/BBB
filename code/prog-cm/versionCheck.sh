#!/bin/bash

#A short program to check versions of dependant programs

#values based on version program was written with, higher versions MAY cause bugs at an undetermined future point. 
#check only evaluates if equal or greater.

#add dependencies below here
depName[0]="bc" # an array containing dependency names. Primarily for error message.
bcvc=$(bc --version) #arbitrary precision calculator language version
check[0]="${bcvc:3:4}" #array makes value to check.
comp[0]="1.07" #array with value to compare against

depName[1]="bash"
bshvc=$(bash --version) #bash version
check[1]="${bshvc:18:3}"
comp[1]="5.0"

depName[2]="dialog"
dvc=$(dialog --version) #dialog version
check[2]="${dvc:9:3}"
comp[2]="1.3"

depName[3]="rsync"
rvc=$(rsync --version) #rsync version
check[3]="${rvc:15:3}"
comp[3]="3.1"

depName[4]="tar"
tvc=$(tar --version) #tar version
check[4]="${tvc:14:3}"
comp[4]="1.3"



for i in ${!check[@]}; do
if [ $(echo "${check[i]} >= ${comp[i]}"|bc -l) -eq 1 ]; then
	:
else
	echo ""
	echo "There is a version error!"
	echo "Found in the following program: ${depName[i]}"
	echo "${check[i]} is not >= ${comp[i]}"
	echo -n "Press [ENTER] to close program"
	read var_blank
	exit
fi
done

#Version_1.00
#Version_Code.MinorChanges

#Change Log:
#2.00: Small tweaks to comments. Added exit stop on first failure. 
#1.00: Created.
