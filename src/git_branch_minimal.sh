#!/bin/bash

SCRIPT_FOLDER=$(dirname $0)

# Function to reset the terminal colors
function color_reset
{
  echo -ne "\033[0m"
}


# Function that displays the branch of a repository
function show_branch
{
  if [ -d $1.git ]; then
	BRANCH=$(git --git-dir=$1.git branch | grep "*" | awk '{print $2}')

	#echo $MFILES
	CPATH=$(pwd)
	cd $1
	MFILES=$(git ls-files -m)
	OFILES=$(git ls-files -o --exclude-standard)
	DFILES=$(git ls-files -d)
	SFILES=$(git ls-files -s)
	UFILES=$(git ls-files -u)
	AHEAD=$(git status | grep ahead -c)
	BEHIND=$(git status | grep behind -c)
	CANFF=$(git status | grep fast-forwarded -c)
	cd $CPATH
	
	STATE_MODIFIED=false
	STATE_UNTRACKED=false
	STATE=""
	if [ -n "$MFILES" ]; then
	  if [ -n "$STATE" ]; then
	      STATE=$STATE","
	  fi
	  STATE=$STATE"modified"
	fi
	if [ -n "$UFILES" ]; then
	  if [ -n "$STATE" ]; then
	      STATE=$STATE","
	  fi
	   STATE=$STATE"unmerged"
	fi
	if [ -n "$OFILES" ]; then
	  if [ -n "$STATE" ]; then
	      STATE=$STATE","
	  fi
	   STATE=$STATE"untracked"
	fi
	if [ -n "$DFILES" ]; then
	  if [ -n "$STATE" ]; then
	      STATE=$STATE","
	  fi
	  STATE=$STATE"deleted"
	fi
	if [ -z "$STATE" ]; then
	  STATE="${COLOR_GREEN}ok"
	  else
	  STATE="${COLOR_RED}"$STATE
	fi
	if [ $AHEAD -ne 0 ]; then
	  STATE=$STATE",${COLOR_RED}ahead"
	fi
	if [ $BEHIND -ne 0 ]; then
	  if [ $CANFF -ne 0 ]; then
	     STATE=$STATE",${COLOR_RED}behind(ff)"
	  else
	    STATE=$STATE",${COLOR_RED}behind"
	  fi
	fi
	
	NAME=$(basename $1)
	printf "${COLOR_INFO}%-30s   ${COLOR_ITEM}%-30s${COLOR_RESET} %-30b${COLOR_RESET}\n" ${NAME} ${BRANCH} ${STATE}
  fi
}


# List of useful colors
COLOR_RESET="\033[0m"
COLOR_INFO="\033[0;32m"
COLOR_ITEM="\033[1;34m"
COLOR_QUES="\033[1;32m"
COLOR_WARN="\033[0;33m"
COLOR_CODE="\033[0m"
COLOR_BOLD="\033[1m"
COLOR_UNDE="\033[4m"
COLOR_TEST="\E[36m"
COLOR_RED="\e[31m"
COLOR_GREEN="\033[0;32m"


# Get target folder
if [ $# -eq 1 ]; then
  TARGET=$1
else
  TARGET="."
fi

# Read the list of folders
echo ""
echo -e "${COLOR_INFO}List of repositories:${COLOR_RESET}"
echo ""
for FOLDER in ${TARGET}/*/; do
  show_branch "$FOLDER"
done
echo ""
color_reset

