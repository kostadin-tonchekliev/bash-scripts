#!/bin/bash

R='\033[0;31m'
G='\033[0;32m'
B='\033[0;34m'
Y='\033[0;33m'
LB='\033[1;34m'
NC='\033[0m'

echo -e "${G}Converter script v2${NC}"

name=()
i=1

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

cd "${name[$choice1]}"
if [[ $(find . -maxdepth 1 -name 'Done*') == '' ]]
then
	mkdir Done
else 
	echo -e "${R}Done folder already exists${NC}"
	echo -e "${LB}Would you like to delete any previous content inside it?${Y} y/n${NC}"
	while [[ -z $choice ]]
	do
		read choice
		if [[ $choice != "y" && $choice != "n" ]]
		then
			choice=''
			echo -e "${R}Please enter a valid option!${NC}"
		fi
	done

	if [[ $choice == "y" ]]
	then
		rm -rf Done/*
		echo "Done folder cleared"
	fi
	if [[ $choice == "n" ]]
	then
		echo "Okay... Pray it doesn't duck shit up"
	fi
fi

echo -e "${LB}Would you like to compress all of them in one file?${Y} y/n${NC}"
while [[ -z $choice2 ]]
do
	read choice2
	if [[ $choice2 != "y" && $choice2 != "n" ]]
	then
		choice2=''
		echo -e  "${R}Please enter a valid option!${NC}"
	fi
done

if [[ $choice2 == "y" ]]
then
	echo -e "${LB}Please enter desired name:${NC}"
	while [[ -z $com_name ]]
	do
		read com_name
	done
	echo "Converting started"
	find . -maxdepth 2 -type f -not -name 'Done*' -not -name '.DS_Store' | sed 's/ /\\ /g' | sort -V | xargs zip -q Done/"$com_name".cbz
	echo -e "[${G}+${NC}]Done"
fi

if [[ $choice2 == "n" ]]
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

echo -e "${LB}Would you like to move the converted data?${Y} y/n${NC}"
while [[ -z $choice3 ]]
do
	read choice3
	if [[ $choice3 != "y" && $choice3 != "n" ]]
	then
		choice3=''
		echo -e "${R}Please enter a valid choice!${NC}"
	fi
done

converted_name=$(echo ${name[$choice1]} | cut -d '/' -f6)

if [[ $choice3 == "y" ]]
then
	mkdir ~/Desktop/Kindle/Manga/"$converted_name"
	mv "${name[$choice1]}"/Done/* ~/Desktop/Kindle/Manga/"$converted_name"/
	rm -rf Done
fi

if [[ $choice3 == "n" ]]
then
	echo "Exiting script without moving data"
	exit
fi
