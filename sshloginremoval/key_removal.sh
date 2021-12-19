#!/bin/bash

R='\033[0;31m'
G='\033[0;32m'
B='\033[0;34m'
Y='\033[0;33m'
LB='\033[1;34m'
NC='\033[0m'

succ_connections=0
stored_connections=$(wc -l ~/Desktop/scripts/.ssh_log | awk '{print $1}')
i=0
declare -a conn=()

echo -e "${Y}SSH Key checker and remover"
echo -e "${NC}Current stored connections: ${LB}$stored_connections${NC}"
if [[ $stored_connections == 0 ]]
then echo -e "${R}No connections found or stored... ${NC}\nExisting script without changes" ; exit
fi

echo -e "Starting key checking..."

while read line
do
	username=$(echo $line | awk '{print $4}' | sed 's/@/ /g' | awk '{print $1}')
	hostname=$(echo $line | awk '{print $4}' | sed 's/@/ /g' | awk '{print $2}')
	temp=$(ssh -q -T -n $username@$hostname -p18765 ls )
	if [[ -z $temp ]]
	then
		echo -e "${G}[-]${NC}Failed to connect to hostname: $hostname"
	else 
		echo -e "${R}[+]${NC}Succesfully connected to hostname: $hostname with username: $username"
		conn+=( "ssh -q -T -n $username@$hostname -p18765 sed -i '/user/d' ~/.ssh/authorized_keys2 " )
		succ_connections=$((succ_connections+1))
	fi
	temp=0
done < ~/Desktop/scripts/.ssh_log

echo -e "Managed to connect to ${LB}$succ_connections ${NC}SSH connection/ns"
if [[ $succ_connections -gt 0 ]]
then
	echo -e "${B}Do you want to discconnect from the connections (y/n):${NC}"
	while [[ -z $dis ]]
	do
		read dis
		if [[ $dis == 'y' ]]
		then
			for i in "${conn[@]}"
			do
				hostname_curr=$(echo $i | sed 's/@/ /g' | awk '{print $6}')
				$i
				echo -e "${G}[+]Connection to hostname${NC} $hostname_curr ${G}succesfully removed${NC}"
			done
			echo "Removal done, exiting script"
		elif [[ $dis == 'n' ]]
		then	echo "No options selected, exiting script"
		else 
			dis=''
			echo -e "${R}Please select a valid option${NC}"
		fi
	done
else echo -e "${G}No succesfull connections found, existing script without changes${NC}"
fi

cat /dev/null > ~/Desktop/scripts/.ssh_log
