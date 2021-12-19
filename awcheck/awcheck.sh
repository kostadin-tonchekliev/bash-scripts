#!/bin/bash

R='\033[0;31m'
G='\033[0;32m'
B='\033[0;34m'
Y='\033[0;33m'
LB='\033[1;34m'
NC='\033[0m'

declare -a arr
declare -a paths
tmp=1
tmp2=1
apps=$(find . -name 'awstats*' 2>/dev/null)

function spacer { echo '--------------------------' ; }

#Find all installations
for line in $(find ~/ -type d -name 'webstats' -maxdepth 3 2>/dev/null)
do
	paths[${#paths[@]}]=$line
done

echo -e "${B}Awstats Checker ver 1.0${NC}"
spacer

#Output avaible installations
for result in ${paths[@]}
do
	echo "[$tmp]$(echo $result | sed 's/\// /g' | awk '{print $4}')"
	tmp=$((tmp+1))
done

echo -e "${Y}Please select installation to read:${NC}"

while [ -u $inst ]
do
	read inst
	if [[ $inst -gt ${#paths[@]} || $inst == 0 ]]
	then
		echo -e "${R}Please select valid file!${NC}"
		inst=''
	fi
done

#Find all awstats file in the directory
for result in $(find ${paths[$((inst-1))]} -name 'awstats*' -maxdepth 2 2>/dev/null)
do
	arr[${#arr[@]}]=$result
done

#Output available dates
echo -e "${LB}Avaiable Dates${NC}"
for key in "${arr[@]}"
do
	echo "[$tmp2]$(echo $key | sed 's/\// /g ; s/awstats//g' | awk '{print $6}' | sed 's/.\{2\}/& /' | cut -b 1-7)"
	tmp2=$((tmp2+1))
done

#Select desired file
echo -e "${Y}Please select stat file to read:${NC}"
while [ -u $statfile ] 
do
	read statfile
	if [[ $statfile -gt ${#arr[@]} || $statfile == 0 ]]
	then
		echo -e "${R}Please select a valid file:${NC}"
		statfile=''
	fi
done

fileres=$(cat ${arr[$((statfile-1))]})

#Output functions
function visits {
	echo -e "${LB}Top 10 Highest Number of Visits per IP:${NC}"
	hits=$(echo "$fileres" | awk '/BEGIN_VISITOR/,/END_VISITOR/' | sed '/BEGIN/d ; /END/d' | awk '{print $3, $1}' | sort -n -r | head -10)
	if [[ -n $hits ]]
	then
		while read line
		do
			numvisit=$(echo $line | awk '{print $1}')
			ip=$(echo $line | awk '{print $2}')
			if [[ $numvisit -ge 100 ]]
			then
				echo -e "${R}$numvisit${NC}${LB} $ip${NC}"
			else echo -e "${G}$numvisit${NC}${LB} $ip${NC}"
			fi
		done <<< "$hits"
	else echo -e "${R}No visits logged or found${NC}"
	fi
}

function errors {
	echo -e "${LB}Numbers of errors:${NC}"
	err=$(echo "$fileres" | awk '/BEGIN_ERROR/,/END_ERROR/' | sed '/BEGIN/d ; /END/d' | sort -n)
	if [[ -n $err ]]
	then
		while read line
		do
			typerror=$(echo $line | awk '{print $1}')
			numerror=$(echo $line | awk '{print $2}')
			if [[ $numerror -ge 50 ]]
			then
				echo -e "${R}$numerror ${LB}$typerror${NC}"
			else echo -e "${G}$numerror ${LB}$typerror${NC}"
			fi
		done <<< $err
	else echo -e "${R}No errors logged or found${NC}"
	fi
}

function pages {

	echo -e "${LB} Top 10 most visited pages:${NC}"
	pages=$(echo "$fileres" | awk '/BEGIN_SIDER/,/END_SIDER/' | sed '/BEGIN/d ; /END/d' | awk '{print $2, $1}' | sort -n -r | head -10)
	if [[ -n $pages ]]
	then
		while read line
		do
			page=$(echo $line | awk '{print $2}')
			num=$(echo $line | awk '{print $1}')
			if [[ $num -ge 50 ]]
			then
				echo -e "${R}$num ${LB}$page${NC}"
			else echo -e "${G}$num ${LB}$page${NC}"
			fi
		done <<< $pages	
	else echo -e "${R}No visits logged or found${NC}"
	fi

}

spacer
visits
spacer
errors
spacer
pages
