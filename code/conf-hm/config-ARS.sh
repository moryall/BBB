#!/bin/bash

#Config file for folder choices.

#  --- OPTIONS  --- #

#list A. (non name specific names)
#!!!!!! Check your Choices & Program Settings if you change these!!!!!!!
#to alter to not change count, AN00 must have blank enteries in place
AN00=(
	"NULL" #"Root" 
	"Home Hidden Folders" 
	"Home Visible Files" 
	"Games")
#here you can censor an option
LstA=(
#	1 "${AN00[0]}" off 
	2 "${AN00[1]}" off
	3 "${AN00[2]}" off
	4 "${AN00[3]}" off
	)
