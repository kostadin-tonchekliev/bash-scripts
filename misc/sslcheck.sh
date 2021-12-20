#!/bin/bash

R='\033[0;31m'
G='\033[0;32m'
B='\033[0;34m'
Y='\033[0;33m'
LB='\033[1;34m'
NC='\033[0m'

domain=$1

function spacer { echo "-------------------------" ; }

function check_a {	
	get_a=$(dig A +short $domain)
	if [[ -n $get_a ]]
	then
		for ip in $get_a
		do
			echo -e "${LB}A: ${NC}${G}$ip - $(dig +short -x $ip | head -1 )${NC}"
		done
	else echo -e "${LB}A: ${R}Not available or not found${NC}"
	fi
}

function check_www {
	get_www=$(dig A +short www.$domain)
	if [[ -n $get_www ]]
	then
		for result in $get_www
		do
			if [[ -n $(dig +short -x $result) ]] && [[ -z $(dig +short -x $result | grep 'not') ]]
			then
				#fix errors show when www is a cname record
				echo -e "${LB}WWW: ${G}$result - $(dig +short -x $result | head -1)${NC}"
			else echo -e "${LB}WWW: ${G}$result"
			fi
		done
	else echo -e "${LB}A: ${R}Not available or not found${NC}"
	fi
}

function check_aaaa {
	get_aaaa=$(dig AAAA +short $domain)
	if [[ -n $get_aaaa ]]
	then
		for aaaa in $get_aaaa
		do
			echo -e "${LB}AAAA: ${R}$aaaa${NC}"
		done
	else echo -e "${LB}AAAA: ${G}No AAAA Records found for $domain${NC}"
	fi
}

function check_www_aaaa {
	get_www_aaaa=$(dig AAAA +short www.$domain)
	if [[ -n $get_www_aaaa ]]
	then
		for wwwaaaa in $get_www_aaaa
		do
			echo -e "${LB}WWW AAAA: ${R}$wwwaaaa${NC}"
		done
	else echo -e "${LB}WWW AAAA: ${G}No AAAA Records found for www.$domain${NC}"
	fi
}

function check_dnssec {
	dnssec=$(whois $domain | grep -i 'DNSSEC' | awk '{print $2}' | sort -u )
	if [[ -n $dnssec ]]
	then
		if [[ $dnssec =~ 'unsigned' ]]
		then
			echo -e "${LB}DNSSEC: ${G}$dnssec${NC}"
		else echo -e "${LB}DNSSEC: ${R}$dnssec${NC}"
		fi
	else echo -e "${LB}DNSSEC: ${G}Not available${NC}"
	fi
}

echo -e "${Y}SSL Checker${NC}"
spacer
check_a
spacer
check_www
spacer
check_aaaa
spacer
check_www_aaaa
spacer
check_dnssec
