#!/bin/bash

R='\033[0;31m'
G='\033[0;32m'
B='\033[0;34m'
Y='\033[0;33m'
LB='\033[1;34m'
NC='\033[0m'

default_wp_htaccess="# BEGIN WordPress\n\nRewriteEngine On\nRewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]\nRewriteBase /\nRewriteRule ^index\.php$ - [L]\nRewriteCond %{REQUEST_FILENAME} !-f\nRewriteCond %{REQUEST_FILENAME} !-d\nRewriteRule . /index.php [L]\n\n# END WordPress"

opt=$1
curr_date=$(date +%d-%m-%y)

function space {
	echo "---------------------------"
}

function htac_fix {
	echo -e "${LB}Begin .htaccess for main WordPress directory fix${NC}"
	deny_counter=$(grep -c 'deny' .htaccess)
	if [[ -n $(find . -name '.htaccess') ]]
	then
		echo -e "${G}.htaccess found${NC}"
		mv .htaccess .htaccess$curr_date
		echo -e "$default_wp_htaccess" >> .htaccess
		echo -e "${Y}Copying Done${NC}"
		echo -e "${Y}Old .htaccess lines: ${NC}" $(wc -l .htaccess$curr_date | awk '{print $1}')
		echo -e "${Y}New .htaccess lines: ${NC}" $(wc -l .htaccess | awk '{print $1}')
		if [[ $deny_counter -gt 0 ]]
		then
			echo -e "${R}$deny_counter deny rules found${NC}"
		else echo -e "${Y}No deny rules found${NC}"
		fi
	else echo -e "${R}.htaccess not found${NC}"
	fi
}

function htac_fix_admin {
	echo -e "${LB}Begin .htaccess for admin WordPress directory fix${NC}"
	status_admin=$(find wp-admin/ -name '.htaccess')
	if [[ -n $(find wp-admin/ -name '.htaccess') ]]
	then
		deny_counter=$(grep -c 'deny' wp-admin/.htaccess)
		echo -e "${R}.htaccess found${NC}"
		mv wp-admin/.htaccess wp-admin/.htaccess$curr_date
		if [[ $deny_counter -gt 0 ]]
		then
			echo -e "${R}$deny_counter deny rules found${NC}"
		else echo -e "${Y}No deny rules found${NC}"
		fi
		echo $deny_counter
	else echo -e "${G}.htaccess not found${NC}"
	fi
}

function perm_reset {
	echo -e "${LB}Begin reset of permissions${NC}"
	find . -type d -exec chmod 0755 {} \; && find . -type f -exec chmod 0644 {} \; 
	echo -e "${G}Permissions reset${NC}"
}

function cache_clear {
	echo -e "${LB}Begin cache clear${NC}"
	wp cache flush
	wp sg purge
	wp rewrite flush
	wp cache flush --skip-plugins --skip-themes
	wp sg purge --skip-plugns --skip-themes
	wp rewrite flush --skip-plugins --skip-themes
	wp transient delete --expired
	wp elementor flush_css --skip-themes
	rm -rf wp-content/cache/*
	rm -rf ~/.opcache/*
	echo -e "${G}Cache succesfully cleared${NC}"
}

function htac_rev {
	if [[ -n $(echo $opt | grep r) ]]
	then
		if [[ -n $(find . -name "*$curr_date") ]]
		then 
			mv .htaccess$curr_date .htaccess
			echo -e "${G}Changes succesfully reverted${NC}"
		else echo -e "${R}No changes find to reset${NC}"
		fi
		if [[ -n $(echo $opt | grep 'd') ]]
		then
			rm wpfixme.sh
			echo -e "${R}Script Deleted${NC}"
		fi
		exit
	fi
}

if [[ -z $(find . -name 'wp-config.php') ]]
then
	echo -e "${R}No WordPress Installation found or it isn't properly set${NC}"
	exit
fi

htac_rev
htac_fix
space
htac_fix_admin
space
perm_reset
space
cache_clear
space

if [[ -n $(echo $opt | grep 'd') ]]
then
	rm wpfixme.sh
	echo -e "${R}Script Deleted${NC}"
fi
