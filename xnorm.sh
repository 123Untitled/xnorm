#!/bin/bash

############## X N O R M // semi-automatic norminette fixer

COLOR="\e[32m"
RESET="\e[0m"
EDITOR="nvim"
ALT_EDITOR="vim"

function NORM {
	SRCH=`norminette $1`
	FILE=`grep -i "error\!" <<< "$SRCH" \
	| awk '{print $1}' \
	| head -1 \
	| grep -o '[^:]*'`
}

function GET_ERROR {
	LINE=`grep -i "Error:" <<< "$SRCH" | sed -n 1p`
	ERRR=`awk '{print $2}' <<< "$LINE"`
	XPOS=`awk '{print $6}' <<< "$LINE" \
	| grep -o '[0-9]\+'`
	YPOS=`awk '{print $4}' <<< "$LINE" \
	| grep -o '[^,]*'`
}


printf "\n%18b %b\n" \
"X N O R M" "$COLOR><$RESET"
while true; do
	NORM;
	if [ -n "$FILE" ]; then
		GET_ERROR;
		printf "%18b%b\n\n" "$FILE" " /> $COLOR$ERRR$RESET";
		read -s -n 1 INPUT;
		if [ "$INPUT" = "y" ] || [ "$INPUT" = "" ]; then
			if ! command -v $EDITOR &> /dev/null;
				then EDITOR=$ALT_EDITOR; fi
			$EDITOR $FILE "+call cursor($YPOS, $XPOS)";
		else break; fi
	else printf "\n"; break; fi
done
