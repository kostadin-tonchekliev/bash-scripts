#!/bin/bash

files=$(find . -maxdepth 1 -type f -name '*.rar')

if [[ -z  $files ]]
then
	echo "No rar files found, exiting script"
	exit
fi

if [[ $1 == '-help' ]]
then
	echo -e "Available options:\n[-x]\t-\tRemoves origin file\n[-m]\t-\tMoves origin file into destination folder"
	exit
fi

for file in $files
do
	path=$(echo $file | sed 's/.rar//')
	mkdir $path
	unrar x -y $file $path

	if [[ $1 == '-x'  ]]
	then
		echo rm
		#rm $file
	fi

	if [[ $1 == '-m' ]]
	then
		mv $file $path/
	fi
done
