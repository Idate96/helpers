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
	HASH=$(git --git-dir=$1.git  rev-parse HEAD)
	
	NAME=$(basename $1)
	echo "----------------------------------------------------------------------------"
	echo -e "${COLOR_INFO}Folder: ${NAME} [${COLOR_ITEM}${BRANCH}${COLOR_INFO}]${COLOR_RESET}" 
	#echo $MFILES
	CPATH=$(pwd)
	cd $1
	git status
	cd $CPATH

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
for FOLDER in ${TARGET}/*/; do
  show_branch "$FOLDER"
done
echo ""
color_reset

