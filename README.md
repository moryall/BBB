# Bodged Bash Backup
A few bash files to help backup my Ubuntu 20.04 computer. This script utilizes bash (obviously), as well as tar and rysnc for the actual work, and dialog for the 'menus,' and a few other programs for safe drive removal. As the name states this is bodged together from numerous google searches and stack exchange answers with my own flair. 

Essentially, I got too tired of remembering the exact and specific commands I'd run to backup my computer while retaining some flexibility of doing it myself in terminal. Although it's complex because of my rudimentarry skill, I do think that altering this to backup things in a specific way unique to any user is relatively easy. I tried to design things with customizability and alterations in mind. Alteration can be done in at various levels, from config (to make work for YOUR ~files and ~folders) to commented code. I have high hopes for version 3 in increasing usability, security, and modification. 

## Use
Run rsync and tar to back up files to either the location that BBB is in, a specific mounted drive, or in any specified location. 

## How to Use BBB

The following assume no modification to code merely configuration files. This is primarily going to backup files in /home/<user name>.

### Setup
#### Minimal
1) Place the BBB folder either where you would like it to go or in home.
2) Change config files in code/conf-hm to get specific folders in your home directory that you might want to backup (you can choose to actually run folders in program). 
3) If you are using BBB in the output location, or specifying manually in program you are all set! If you are wanting to use driveCheck to ensure your backup drive is mounted and the correct one, see "How to Use driveCheck" below. 
#### Moderate
All of the above, but check out tar.sh and rsync.sh if you want to know what the "default" options are for these programs.
#### Advanced
Utilize driveCheck, by placing UUID's in driveCheck & your local fstab (and crypttab as needed), see below. 

### Running
1) Run the file "BKUP-RUN.sh
2) Follow prompts and double check information on final prompt. 
3) Utilize logs and debug if you need to figure out what you selected. Logs are saved in the BBB/logs (note: logs do not auto clear, so...delete them when you don't need them)
4) Run and enjoy watching all the verbose action. 

## How to Use driveCheck
Withing the BBB/code/prog-cm folder you can find driveCheck and driveAttach. Both work very similiarly. DriveCheck is used to ensure a drive is in the right place before backing up to it. DriveAttach is a tool for simply opening luksCrypt devices, mounting specific hard drives in locations, and closing and safely removing devices. 

### Setup
1) First gather you external backup drives UUID, if it's encrpyted you will need to have it opened. My prefered method is to run:
```bash
lsblk -e7 -o NAME,LABEL,MOUNTPOINT,TYPE,uuid,name,SIZE
```
You can find this as part of driveAttach upon opening. 
2) Enter the partition UUID (/dev/sd[letter]) and a brief description in the header (this is the same in driveAttach.)
3) Follow guides to enter mounting places for your drive as appropriate in fstab and crypttab (out of scope for here).
4) Add a unique "check" variable string for each drive and place the corresponding text in a file titled "check.file" in primary directory of the drive (the one that will attach to destined mountpoint). It's a simple fail safe, not "secure" or "unspoofable."

### Use
1) There are several ways to use driveCheck, and BBB only uses one! To run driveCheck you can run it with with the bash command (with or without specified options):
```bash
bash ./driveCheck.sh [operation mode] [output option] <tempfile>
```
Or run it internally from another script with specified options as variables $OM $OO $tmpMNTS (respective to above over):
```bash
source ./driveCheck.sh
```
2) If you do not have a mode or option in will prompt and confirm with you a choice in display. Operating Modes are as follows: list, mounts, dialog. Output Options are: display, file, variable. 

3) Depending on settings results may vary! <tempfile> will default to location of same directory if not specified and requested.

#### Settings: Operation Modes
Operating Modes are how drives that pass check are listed.
1) list: this will provide a list of the drive number (as numbered in the array) of any specified drive attached (and passed check), it's mountpoint, and it's description. 
2) mounts: this provides only a list of mountpoints.
3) dialog: produces a result ready to go into a dialog checklist; this format is between the brackets (not including): [number "mount point" off] for each drive.   

#### Settings: Output Options
Output Options are how/where the mode data is sent in my unelegant way. 
1) display: simply displays the data in STDOUT (I think...that's what it's called).
2) file: this outputs to a file, default name is "tmpMNTS.txt" in the same directory if not specified. Option will not be promted to specified on manual entry and must be preset. 
3) variable: Only really useful it running as sourced, this will output to a array variable called ${MOUNT_POINTS[]} containing the relevant mode's string. 


## License 

Copyright 2022 owner: moryall on github
[MIT](https://choosealicense.com/licenses/mit/)






