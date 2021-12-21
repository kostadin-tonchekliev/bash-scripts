#!/bin/bash

num=$(find ~/Desktop/Screenshots/ -type f -name 'Screenshot*' | wc -l | sed 's/ //g')
if [[ $num -gt 0  ]]
then
	rm ~/Desktop/Screenshots/Screenshot*
	echo -e "\033[0;31m$num\033[0m Screenshots succesfully removed"
else echo -e "\033[0;31m No Screenshots found \033[0m"
fi
