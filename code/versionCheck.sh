#!/bin/bash

#a short program to check versions of dependant programs

#values based on version program was written with, higher versions MAY cause bugs at an undetermined point. 
#check only evaluates if equal or greater.

#add dependencies
depName[0]="bc"
bcvc=$(bc --version)
check[0]="${bcvc:3:4}"
comp[0]="1.07"

depName[1]="bash"
bshvc=$(bash --version)
check[1]="${bshvc:18:3}"
comp[1]="5.0"

depName[2]="dialog"
dvc=$(dialog --version)
check[2]="${dvc:9:3}"
comp[2]="1.3"

depName[3]="rsync"
rvc=$(rsync --version)
check[3]="${rvc:15:3}"
comp[3]="3.1"

depName[4]="tar"
tvc=$(tar --version)
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
fi
done

#Version_1.00
#Version_Code.MinorChanges

#Change Log:
#1.00: Created

