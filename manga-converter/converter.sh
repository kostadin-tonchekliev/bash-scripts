#!/bin/bash

#Initial variables
R='\033[0;31m'
G='\033[0;32m'
B='\033[0;34m'
Y='\033[0;33m'
LB='\033[1;34m'
NC='\033[0m'

echo -e "${G}Converter script v3${NC}"
name=()
i=1

#Main Checker function for making sure that the entered choice is a valid one
function checker() {
	while true; do
		read -n 1 -rep "--: " cur_choice
		if [[ $(grep -Eic "y|n" <<< "${cur_choice}") == 1 ]]; then
			export cur_choice
			break
		fi
	done
}

#Detects existing folders and allows you to select one
for folder in ~/Documents/HakuNeko/*/
do
	name+=("$folder")
done

echo -e "${LB}Choose name:${NC}"
for title in "${name[@]}"
do
	echo -e "[$i]${Y}$(echo $title | cut -d '/' -f6)${NC}"
	i=$((i+1))
done

#Checker if the selected folder is a valid one
while [[ -z $choice1 ]]
do
	read choice1
	if [[ $choice1 > ${#name[@]} || $choice1 == 0 ]]
	then
		echo -e "${R}Please select valid name${NC}"
		choice1=''
	fi
done

choice1=$((choice1-1))

#Checks and makes the main Done folder where everthing is compressed
cd "${name[$choice1]}"
if [[ $(find . -maxdepth 1 -name 'Done*') == '' ]]
then
	mkdir Done
else 
	echo -e "${R}Done folder already exists${NC}"
	echo -e "${LB}Would you like to delete any previous content inside it?${Y} y/n${NC}"
	checker
	if [[ "$cur_choice" == "y" ]]
	then
		rm -rf Done/*
		echo "Done folder cleared"
	elif [[ "$cur_choice" == "n" ]]
	then
		echo "Okay... Pray it doesn't duck shit up"
	fi
	unset cur_choice
fi	

#Allows you to compress all files into a single one or into individual ones
echo -e "${LB}Would you like to compress all of them in one file?${Y} y/n${NC}"
checker
if [[ "$cur_choice" == "y" ]]
then
	echo -e "${LB}Please enter desired name:${NC}"
	while [[ -z $com_name ]]
	do
		read com_name
	done
	echo "Converting started"
	find . -maxdepth 2 -type f -not -name 'Done*' -not -name '.DS_Store' | sed 's/ /\\ /g' | sort -V | xargs zip -q Done/"$com_name".cbz
	echo -e "[${G}+${NC}]Done"
elif [[ "$cur_choice" == "n" ]]
then
	for d in */
	do
		file_name=$(echo "$d" | sed 's/ //g ; s/\///g')
		if [[ "$file_name" != "Done" ]]
		then
			echo "Current chapter: $file_name"
			find "$d" -maxdepth 1 -type f -not -name 'Done*' | sed 's/ /\\ /g' | sort -V | xargs zip -q Done/$file_name.cbz
			echo -e "[${G}+${NC}]Done"
		fi
	done
fi
unset cur_choice

#Allows you to move all of the converted files into the main Manga folder or stays where it is
echo -e "${LB}Would you like to move the converted data?${Y} y/n${NC}"
converted_name=$(echo ${name[$choice1]} | cut -d '/' -f6)
checker
if [[ "$cur_choice" == "y" ]]
then
	mkdir ~/Desktop/Kindle/Manga/"$converted_name"
	mv "${name[$choice1]}"/Done/* ~/Desktop/Kindle/Manga/"$converted_name"/
	rm -rf Done
elif [[ "$cur_choice" == "n" ]]
then
	echo "Exiting script without moving data"
	exit
fi
