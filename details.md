# Details
Further documentation as to the details of the script files.

## Directory Structure

) to indicate folders

\> to indicate files

*denotes folder or files auto generated

```bash
)BBB - #home to the program also known as $srcd
    ) temp* - #houses temporary files for transfering variables
    ) logs* - #all output logs & debugs go here by date
        > yyyy-mm-dd_log-x.txt* - #will gain new sequence per day & interation
        > yyyy-mm-dd_log-x.txt* - #will gain new sequence per day & interation
    ) code - #houses program code
        ) conf-hm  - #configuration files for home backup
            > config-A.sh - #config for A folders used in both
            > config-B.sh - #config for B folders used in both
            > config-GM.sh - #config for game folders in both
            > config-HID.sh - #config for hidden folders in both
        ) prog-cm  - #program files used universally (may need different config file)
            > dialogDisplay.sh - #Changest dialogrc file in /etc to custom specified
            > dialogrc-purple - #custom dialogrc file used by dialogDisplay
            > driveAttach.sh - #stand alone mount/decrypt program
            > driveCheck.sh - #stand alone tool to check drive mount location accuracy 
            > versionCheck.sh - #Checks depedencies for common commands in BBB
        ) prog-hm  - #program files used for home backup
            > dialog.sh - #the main body of choice selection and preperation
            > rsync.sh - #the main rsync program
            > tar.sh - #the main tar program
        )prog-srv - #program files used for server backup
            > server.sh - #small program for backing up server.
            > srvAttach.sh - #same as driveAttach but for server's backups.
            > srvCheck.sh - #same as driveCheck but for server's backups.
    > com.sh - #common variables used in all programs. Called mainly by master.sh
    > master.sh - #main program that determines what other programs and config files
    > var.sh - #BBB specific variables. Called mainly by master.sh & RUN
> BKUP-RUN.sh - #the file to run the whole thing as sudo use with caution
> changelog - #on label
> details.md - #this manual
> README.md #the other manual
> ToDo.txt - #a list of future plans/goals
```
## File Details

### ./code/com.sh

#### Description

A list of common vairables to remain constant accross all my programs.

#### Variables

##### *constants:*

Z=0 #a variable for Zero  
O=1 #a variable for One  
T=2 #a variable for Two  

##### *shorts:*

SL="/" #slash  
Sp0=" " #Blank Space  
Sp1=' "' #dialog's option spacer  
Sp2='" off ' #dialog's option spacer  
Sp3="_" #used many places, especially file names  
Sp4="*" #used when wildcard is needed  
Sp5="^" #used as a spacer in variable split/joiner (due to uncommon nature)  

##### *extensions:*

Ext1=".txt"   
Ext2=".tgz"  

### ./code/var.sh

#### Description
A list of variables used across BBB.

#### Variables

##### *variables with starting value*
f_COUNT=0 #counter for repeats of folder select loop  
p_COUNT=0 #counter for repeats of program and folders loops  
n_COUNT=0 #counter for repeats of name, program, folder loops  
L_COUNT=0 #counter for repeats of location, name, program, folder loops  

##### *words*
Wd1="Backup" #Used to make tar files  
Wd2="Log" #Used to make log location/file  
Wd3="Debug" #Used to make debug location/file  
Wd4="tmp" Used to make location/file  
Wd5="rsync" #word used for name of rsync folder  
Wd6="tar" #word used for name of tar folder  
 
##### *folders*
FL0="home"  
FL1="logs"  
FL2="temp"  
FL3="code"  

##### *programs*
Prog00="master.sh"  
Prog01="dialog.sh"  

##### *program choice*
PG01="rsync"  
PG02="tar"  
PG03="both - same folders"  
PG04="BOTH - different folders"  

##### *program default option (must end with a space!)*
RSYNC_OPTIONS="--delete "  

##### *meta*
PRGNM="BBB"  
Ver="2.00.00"

### ./code/conf-hm/config-A.sh
#### Description
Config file for folder choices A. Used for unique or complex folders. Can't use Circumflexes.

#### Variables
FldA=("Folder A" "Folder B" "...") #Names of folders (only used for display)  
LstA=(1 "\"${FldA[0]}\"" off 2 "\"${FldA[1]}\"" off ...) #Used for Dialog Choices  
KpAR=("0" "3" ...) #Used to make a limited selections of LstA for tar.  

### ./code/conf-hm/config-B.sh
#### Description
Config file for folder choices B. Used for repeatable folders in user's home folder. Can't use Circumflexes.

#### Variables
FldB=("Folder A" "Folder B" "...") #Names of folders (as written, case sensitive)

### ./code/conf-hm/config-GM.sh
#### Description
Config file for repeatable folder in user's home folder. Can't use Circumflexes.

#### Variables
GameAr=("Folder A" "Folder B" "...") #Names of folders (as written, case sensitive)

### ./code/conf-hm/config-HID.sh
#### Description
Config file for repeatable folder in user's home folder. Can't use Circumflexes.

#### Variables
HID=("Folder A" "Folder B" "...") #Names of folders (as written, case sensitive)

### ./BKUP-RUN.sh
#### Description
Small Utility to: 1) ensure dependencies, 2) get sudo access for entire rest of script, 3) to get basic information about user and location to pass to main program via temp files, 4) remove temp files.

#### Source
##### *pulls*
source ./code/com.sh  
source ./code/var.sh  
##### *opens*
source ./code/prog-cm/versionCheck.sh  
##### *runs*
sudo bash ./$Fl3$SL$PG00 (i.e. ./code/master.sh)  

#### Variables
cwd=${PWD%/*} #grabs one level up for Constant Working Directory  
srcd=$(pwd) #SouRCe Directory for shorter refernce to logs and code  
N=$(whoami) #grabs user name while non-sudo  
DC=$(date +%Y-%m-%d) #create Date Code for files (persistent through batch)  

#### Temp Files
tmpA="$srcd$SL$FL2$SL$Wd4-cwd$Ext1" #holds Constant Working Directory  
tmpB="$srcd$SL$FL2$SL$Wd4-srcd$Ext1" #holds SouRCe Directory  
tmpC="$srcd$SL$FL2$SL$Wd4-N$Ext1" #holds user name  
tmpD="$srcd$SL$FL2$SL$Wd4-DC$Ext1" #holds Date Code  

### ./code/prog-cm/versionCheck.sh
#### Description
A short program to check versions of dependant programs. Utilized --version and program specific cutting to compare >= version written with. Will stop at first unmet.

#### Variables
depName[x] # an array containing dependency names. Primarily for error message.  
check[x]="${<variable>:<start read>:<read count>}" #array makes value to check.  
comp[x]="<specified version #>" #array with value to compare against.  
bcvc=$(bc --version) #arbitrary precision calculator language version.  
bshvc=$(bash --version) #bash version  
dvc=$(dialog --version) #dialog version  
rvc=$(rsync --version) #rsync version  
tvc=$(tar --version) #tar version  

### ./code/master.sh
#### Description
Contains the main shell window for sub-programs in sudo access. Acomplishes: 1) Sizing the screen, 2) loading in var & com variables, 3) Reload temp variables from prior to sudo, 4) Make log/debug files, 5) pull main sub-programs. 

#### Source
##### *pulls*
source ./code/com.sh  
source ./code/var.sh  
temp files: i.e. ./temp/tmp<name>.txt  
##### *opens*
source ./code/prog-hm/dialog.sh  
source ./code/conf-hm/config-HID.sh  
source ./code/conf-hm/config-GM.sh  
source ./code/prog-hm/rsync.sh  
source ./code/prog-hm/tar.sh  

#### Variables
##### *Redeclares those from BKUP-RUN*
log=$srcd$SL$FL1$SL$DC$Sp3$Wd2 #should be $srcd/logs/yyyy-mm-dd_Log  
debug=$srcd$SL$FL1$SL$DC$Sp3$Wd3 #should be $srcd/logs/yyyy-mm-dd_Debug  

### ./code/prog-cm/dialogDisplay.sh
#### Description
Small utility to add in color preferences and remove them on a temporary basis.

#### Variables
DISPLAY_FILE The title of the costum display file, should be located in same dir.   
DISP_LOC Location of prog and display file. Must end in a slash.  
DISPLAY_PRESET [start|stop], used when calling script internally.  
DISPLAY_SETTING [start|stop], can be entered manually after running or pulled from $1.  

### ./code/dialog.sh
#### Description
The main program responsible for: 1) generating GUI, 2) Collects options needed for tasks.

#### Source
##### *uses (via ./code/master.sh)*
source ./code/com.sh  
source ./code/var.sh  
temp files: i.e. ./temp/tmp<name>.txt  
##### *pulls*
source ./code/conf-hm/config-A.sh  
source ./code/conf-hm/config-B.sh  

#### Variables
##### *dialog exit status codes*
: ${DIALOG_OK=0}  
: ${DIALOG_CANCEL=1}  
: ${DIALOG_HELP=2}  
: ${DIALOG_EXTRA=3}  
: ${DIALOG_ITEM_HELP=4}  
: ${DIALOG_ESC=255}  
? #the exit code for any command. Best results, use umediately after command.   
return_value=$? #recurring return value variable.   
cmd=(dialog ...) #variable used to write part of a dialog before running it  

##### ***Dialogs***
##### *Program choice*
PgOpt=(1 "$PG0x" off ...) #array with labels for program choices.  
Pg=$(...) #run fully compiled dialog command, puts output into var.  
PgD="# <PG0x Title>" #Program Decision.  
OptRS #binay 0=no 1=yes for choice of rsync.  
OptTar=0 #binay 0=no 1=yes for choice of tar.  
Lp #number of times through folder options loop.  

##### *RS options*
RS_Options #defualt RSYNC_OPTIONS (from var.sh) can be edited, must end in space.  
RS_Opt_ON= #binay 0=off 1=on for choice of options being on or off.  

##### *Folder options*
LstAR #filtered list of LstA via limiter KpAR, to be used to rsync.  
LstAT #completed copy of LstA for use with tar.  
LstA #redeclated in loop as AR or AT depending on choice.  
OPTION_TXT #states message regarding which folder options loop selection is for.   
NumB #A 1-x generated sequence for entries in FldB to make LstB.  
LstB #Folders and numbers for display in options.  
ChA #the selected choices of FldA (all numerical space seperated).  
ChB #the selected choices of FldB (all numerical space seperated).  
OutA1 #The output of ChA during loop 1 (all numerical space seperated).  
OutB1 #The output of ChB during loop 1 (all numerical space seperated).  
OutA2 #The output of ChA during loop 2 (all numerical space seperated).  
OutB2 #The output of ChB during loop 2 (all numerical space seperated).  

##### *Variable maker (prepared variables for display and use)*
OUT #depending on itteration one of the OutA/B;1/2  
FLD #depending on itteration corresponding FldA/B  
Var1 #temp array; choice #s as seperate array items  
Var2 #temp string; choice number, space, folder, circumflex (for seperation uses $Sp5)  
Var3 #temp array; choice number, space, folder  
Var4 #temp string; folder, circumflex  
Var5 #temp array; folder per array item.  
PRINT #temp array; copy of Var3 as per line for display.  
TRASH #trash variable when Var5 is not used.  
PRINTA1 #dependent on itteration; permanent $PRINT for A1.  
PRINTB1 #dependent on itteration; permanent $PRINT for B1.  
PRINTA2 #dependent on itteration; permanent $PRINT for A2.  
PRINTB2 #dependent on itteration; permanent $PRINT for B2.  
CFB1 #Permanent copy of Var5 for FldB choices on loop one - to be used in rsync.   
CFB2 #Permanent copy of Var5 for FldB choices on loop two - to be used in tar.   

##### *Confirmation*
REDO_OPTIONS #array with possible restart points  
REDO_CH #numerical choice of redo points  

#programs
PATHIN #Used in both tar and rsync cleared for clarity  
PATHOUT #Used in both tar and rsync cleared for clarity   
INPUT #used slightly differently in rsync and tar; cleared between programs  
OUTPUT #used slightly differently in rsync and tar; cleared between programs  

#### Temp Files
TmpUser="tmpUser.txt" #specifcy temp file for user name  
TmpLoc="tmpLoc.txt" #specifcy temp file for specified output location name  

### ./code/prog-hm/rsync.sh
#### Description
The main program for conducting rsync backups. Rsync runs from folder location with full file paths in & out.

#### Source
##### *uses (via ./code/dialog.sh via ./code/master.sh)*
source ./code/com.sh  
source ./code/var.sh  
source ./code/conf-hm/config-HID.sh  
source ./code/conf-hm/config-GM.sh  
temp files: i.e. ./temp/tmp<name>.txt  
##### *uses (via ./code/dialog.sh)*
source ./code/conf-hm/config-A.sh  
source ./code/conf-hm/config-B.sh  

#### Inputs
$OutA1 #see dialog.sh  
$OutB1 #see dialog.sh  
$HID #see config-HID.sh  
$GameAR #see config-GM.sh  
$RS_Options #see dialog.sh  
$CFB1 #see dialog.sh  
 
#### Variables
PRGNM="BKUP_rsycn" #name of sub-program  
Ver="x.xx" #sub-program version  
PATHIN="$SL$FL0$SL$N$SL" #/home/user/  
PATHOUT="$cwd$SL$Wd5" #$cwd/rsync ($Wd5 from var.sh; no / at end)  
INPUT #variable string made with $PATHIN as needed by the settings  
OUTPUT #variable string made with $PATHOUT as needed by the settings  
E #Exclusion criteria for FldA choices set in file.  

### ./code/prog-hm/tar.sh
#### Description
The main program for conducting tar backups. Tar runs from destination location with full file paths in and must have working directory be in destination.

#### Source
##### *uses (via ./code/dialog.sh via ./code/master.sh)*
source ./code/com.sh  
source ./code/var.sh  
source ./code/conf-hm/config-HID.sh  
source ./code/conf-hm/config-GM.sh  
temp files: i.e. ./temp/tmp<name>.txt  
##### *uses (via ./code/dialog.sh)*
source ./code/conf-hm/config-A.sh  
source ./code/conf-hm/config-B.sh  

#### Inputs
$OutA2 #see dialog.sh  
$OutB2 #see dialog.sh  
$HID #see config-HID.sh  
$GameAR #see config-GM.sh  
$CFB2 #see dialog.sh  

#### Variables
PRGNM="BKUP_tar" #name of sub-program  
Ver="x.xx" #sub-program version  
PATHIN="$SL$FL0$SL$N$SL" #/home/user/  
PATHOUT="$cwd$SL$Wd6" #$cwd/tar ($Wd6 from var.sh; no / at end)  
INPUT #variable string made with $PATHIN as needed by the settings  
OUTPUT #used for log file description of work  
TITLE #variable titles for file name  
OP_LOC #variable OutPut LOCation  


### ./code/prog-cm/driveAttach.sh
#### Description
Stand alone program used to mount/decrypt, unmount/close, and safely remove drives. heavely relies on preconfiguration of fstab and crypttab. Do not SOURCE w/ driveCheck.

#### Source
/etc/crypttab 
/etc/fstab 

#### Inputs
In top of file specify: PART=UUID and DESC=Description

#### Variables
PART[#]="<string>" #Partition UUID for drive to be mounted (if crypt seen in crypttab)  
DESC[#]="<sting>" #Human readable description of equivilent PART[#]  
FOUND= #Looks UUID up to get Location (lsblk=name; but with blkid)  
CRYPT_TEST= #Looks UUID up to get crypt Location (lsblk=name) for crypt  
A= #Temp variable, if regular drive will be mount point. Crypt will be blank always.  
B= #Temp variable, if crypt will be mount point.  
DMOUNT_Y[#]= #binary y/n Y=1, if Drive has Mount  
CMOUNT_Y[#]= #binary y/n Y=1, if Crypt has Mount  

##### ***U/MNT = UMNT and equivilent MNT: sem-temp variable***
U/MNT_U[#]= #UUID  
U/MNT_L[#]= #Location (lsblk=name)  
U/MNT_N[#]= #number on list  
U/MNT_D[#]= #description  
U/MNT_M[#]= #mount point  
U/MNT_CL[#]= #Location (lsblk=name) but crypt  
U/MNT_CM[#]= #is Crypt mount point  
U/MNT_CU[#]= #UUID for crypt drive based on crypt mountpoint from fstab  
##### ***DRIVE_ equivelents and display made from OC choice, either of UMNT or MNT.***  
DRIVE_U[#]= #UUID  
DRIVE_L[#]= #Location (lsblk=name)  
DRIVE_N[#]= #number on list  
DRIVE_D[#]= #description  
DRIVE_M[#]= #mount point  
DRIVE_CL[#]= #Location (lsblk=name) but crypt  
DRIVE_CM[#]= #is Crypt mount point  
DRIVE_CU[#]= #UUID for crypt drive based on crypt mountpoint from fstab  

##### *Inputs*
OC= #Open / Close choice. Accepted inputs and equivilants: [cancel|exit] [open|mount|decrypt] [close|encrypt] [remove|disconnect].  
SEL= #numerical selection of drive. From DRIVE/U/MNT_N[#]= which is true to original numbering in header   
check= #temp variable for user confirmation of selection  

##### *change from specified array entry to single variables to reduce error.* 
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

MOUNT= #is specific end mountpoint to use with u/mount cmd  
DRIVE= #Looks UUID up to get full DISK Location (lsblk=name; but with blkid); for eject  


### ./code/prog-cm/driveCheck.sh
#### Description
Checks if A) specified drive is present, B) ensures check.file contains specified string at given mountpoint. Can run as program (will prompt options), or with inputs.

#### Usage
bash ./driveCheck.sh [operation mode] [output option] <tempfile>  
source ./driveCheck.sh [operation mode] [output option] <tempfile>  
specify $OM & $OO (optionally $tmpMNTS) and use source ./driveCheck.sh  
##### *Modes: list, mounts, dialog*
    list: output will list drive as <#) Mnt/loc: Description>  
	mounts: output will list drives as <Mnt/loc>  
	dialog: output will list drives as <# "Mnt/loc" off>  
##### *Outputs: display, file, variable*
	display: will output to standard output
	file

#### Source
/etc/crypttab  
/etc/fstab  

#### Inputs
In top of file specify PART=UUID, CHECK=<specific string> and DESC=Description  

#### Variables
PART[#]="<string>" #Partition UUID for drive to be mounted (if crypt seen in crypttab)  
DESC[#]="<string>" #Human readable description of equivilent PART[#]  
CHECK[#]='<string>' #Random string to match in associated check.file  
FOUND= #Looks UUID up to get Location (lsblk=name; but with blkid)  
CRYPT_TEST= #Looks UUID up to get crypt Location (lsblk=name) for crypt  
A= #Temp variable, if regular drive will be mount point. Crypt will be blank always.  
B= #Temp variable, if crypt will be mount point.  
DMOUNT_Y[#]= #binary y/n Y=1, if Drive has Mount  
CMOUNT_Y[#]= #binary y/n Y=1, if Crypt has Mount    
DRIVE_NUM[#]= #number on list  
DRIVE_MNT[#]= #mount point  
DRIVE_DESC[#]= #description  
File= #takes Mnt/loc and appends /check.file to be used to compare check value  
Manual_1Y= #binary y/n Y=1, for if any manual input. signaling need for varification.  
Manual_2Y= #binary y/n Y=1, for if any manual input. signaling need for varification.  
 
OM= #Operation Mode [will check if specified, then $1, then prompt]   
OO= #Output Option [will check if specified, then $2, then prompt]   
tmpMNTS= #default temp loc/file to write out. [will check if specified, then $3, never promts]  
check= #temp variable for user confirmation of selection  
MOUNT_POINTS[#]= #variable array with all moutned and check verrified drives.  
