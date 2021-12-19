#!/bin/bash

R='\033[0;31m'
G='\033[0;32m'
B='\033[0;34m'
Y='\033[0;33m'
LB='\033[1;34m'
NC='\033[0m'

in_domain=$1
if [[ $in_domain == "" ]]
then
	echo -e "${R}Please select a domain${NC}"
	exit
fi
domain=$(echo $in_domain | tr 'A-Z' 'a-z')
whois $domain > whoisdom

function space { echo "--------------------------------"; }

function check_expiry {
	expiration_datef=$(cat whoisdom | grep -i 'expiry' | awk '{print $4}' | cut -c 1-10)
	expiration_year=$(echo $expiration_datef | sed 's/-/ /g' | awk '{print$1}')
	expiration_day=$(echo $expiration_datef | sed 's/-/ /g' | awk '{print$3}')
	expiration_month=$(echo $expiration_datef | sed 's/-/ /g' | awk '{print$2}')

	curr_year=$(date +%Y)
	curr_month=$(date +%m)
	curr_day=$(date +%d)
	echo -en "${B}Expiration Date: ${NC}"
	if [ -n "$expiration_datef" ]
	then
		if [ $expiration_year == $curr_year ]
		then
			if [ $expiration_month == $curr_month ]
			then
				if [ $expiration_day -ge $curr_day ]
				then
					#To Do: Make Yellow if the expiration date is the same
					echo -e "${G}$expiration_datef${NC}"
				else echo -e "${R}$expiration_datef${NC}"
				fi
			elif [ $expiration_month -gt $curr_month ]
			then
				echo -e "${G}$expiration_datef${NC}"
			else echo -e "${R}$expiration_datef${NC}"
			fi
		elif [ $expiration_year -gt $curr_year ]
		then
			echo -e "${G}$expiration_datef${NC}"
		else echo -e "${R}$expiration_datef${NC}"
		fi
	else echo -e "${R}Expiration date can't be found or is non-existant${NC}"
	fi
}

function get_registrar {
	registrar=$(cat whoisdom | grep -i 'registrar:' | head -1 | awk '{print $2, $3 ,$4}')
	if [ -n "$registrar" ]
	then
		echo -e "${B}Registrar: ${NC} ${G}$registrar${NC}"	
	else echo -e "${B}Registrar: ${NC}${R}Couldn't be found or doesn't exist${NC}"
	fi
}

function check_status {
	statusdom=$(cat whoisdom | grep -i 'domain status:' | head -2 | awk '{print $3}')
	if [ -n "$statusdom" ]
	then
		for status in $statusdom
		do
			if [[ $status =~ 'Prohibited' ]]
			then
				echo -e "${B}Domain Status:${NC} ${G}$status${NC}"
			elif [[ $status =~ 'ok' ]]
			then 
				echo -e "${B}Domain Status:${NC} ${Y}$status${NC}"
			else echo -e "${B}Domain Status:${NC} ${R}$status${NC}"
			fi
		done
	else echo -e "${B}Domain Status:${NC} ${R}Couldn't be found or doesn't exist${NC}"
	fi
}

function dnsec_check {
	dnsec=$(cat whoisdom | grep -i -w 'dnssec:' | awk '{print $2}')
	if [[ -n $dnsec ]]
	then
		for result in $dnsec
		do	
			if [[ $result =~ "unsigned" ]]
			then
				echo -e "${B}DNSSEC: ${NC}${G}$result${NC}"
			else echo -e "${B}DNSSEC: ${NC}${R}$result${NC}"
			fi
		done
	else echo -e "${B}DNSSEC:${NC} ${R}Couldn't be found or doesn't exist${NC}"
	fi
}

function ns_check {
	ns=$(cat whoisdom | grep -i -w " name server" | awk '{print $3}' | tr 'A-Z' 'a-z')
	if [[ -n $ns ]]
	then
		for nameserver in $ns
		do
			echo -e "${B}NameServer: ${NC}${G}$nameserver${NC}"
		done
	else echo -e "${B}NameServer: ${NC}${R}Coudln't be found or doesn't exist${NC}"
	fi
}
#if [[ $(dig +short -x 35.209.76.164) =~ "googleusercontent" ]]
#then
#	echo kur
#fi

#if [[ $domain =~ 'com' ]]
#then
#	echo -e "${B}Domain: ${LB}$domain${NC}"
#	space
#	echo -en "${B}Expiration Date: ${NC}"
#	check_expiry
#	space
#	get_registrar
#	space
#else echo -e "${R}Not Supported Domain:${NC} ${LB}$domain${NC}"
#fi
	echo -e "${B}Domain: ${LB}$domain${NC}"
	space
	if [[ -n $(cat whoisdom | grep -i 'no match') || -n $(cat whoisdom | grep -i 'no whois') ]]
	then
		echo -e "${R}Domain is invalid or doesn't exist${NC}"
	else
		check_expiry
		space
		get_registrar
		space
		check_status
		space
		dnsec_check
		space
		ns_check
		space
	fi
	rm whoisdom
