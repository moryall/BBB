# Bodged Bash Backup
A few bash files to help backup my Ubuntu 20.04 computer. This script utilizes bash (obviously), as well as tar and rysnc for the actual work, and dialog for the 'menus,' and a few other programs for safe drive removal.

Essentially, I got too tired of remembering the exact and specific commands I'd run to backup my computer while retaining some flexibility of doing it my self in terminal. Although it's complex because of my rudimentarry skill, I do think that altering this to backup things in a specific way unique to any user is relatively easy. I tried to design things with customizability and alterations in mind. 

## Use
Run rsync and tar to back up files to either the location that BBB is in, a specific mounted drive, or in any specified location. 
