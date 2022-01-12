#!/bin/bash

############## X N O R M // semi-automatic norminette fixer

COLOR="\e[32m"
RESET="\e[0m"
EDITOR="nvim"
ALT_EDITOR="vim"
GREP="grep --color=never"

function NORM {
	# execute norminette command with arg
	SRCH=`norminette $1`
	# search file error pattern and get file name
	FILE=`$GREP -i "error\!" <<< "$SRCH" \
	| awk '{print $1}' \
	| head -1 \
	| $GREP -o '[^:]*'`
}

function GET_ERROR {
	# get first error line
	LINE=`$GREP -i "Error:" <<< "$SRCH" | sed -n 1p`
	# get the error name
	ERRR=`awk '{print $2}' <<< "$LINE"`
	# get the x position error
	XPOS=`awk '{print $6}' <<< "$LINE" \
	| $GREP -o '[0-9]\+'`
	# get the y position error
	YPOS=`awk '{print $4}' <<< "$LINE" \
	| $GREP -o '[^,]*'`
}

# print logo
printf "\n%18b %b\n" "X N O R M" "$COLOR><$RESET"
while true; do
	# norminette
	NORM;
	# test if there is errors
	if [ -n "$FILE" ]; then
		GET_ERROR;
		# print file and error name
		printf "%18b%b\n\n" "$FILE" " /> $COLOR$ERRR$RESET";
		# user input read
		read -s -n 1 INPUT;
		# test input user
		if [ "$INPUT" = "y" ] || [ "$INPUT" = "" ]; then
			# check text editor exist
			if ! command -v $EDITOR &> /dev/null;
				# replace by an alternative
				then EDITOR=$ALT_EDITOR; fi
			# open file at x/y error position
			$EDITOR $FILE "+call cursor($YPOS, $XPOS)"
		else break; fi
	# new line when exit
	else printf "\n"; break; fi
done
