#!/bin/bash

R='\033[0;31m'
G='\033[0;32m'
B='\033[0;34m'
Y='\033[0;33m'
LB='\033[1;34m'
NC='\033[0m'

function space {
	echo "--------------------"
}

echo -e "${LB}Cache Clean v0.1, ${NC}${R}to be ran only in the WordPress Directory!${NC}"
space

if [[ -z $(find . -maxdepth 1 -name 'wp-config.php') ]]
then
	echo -e "${R}No valid WordPress Installations found${NC}"
	exit
fi

echo -e "${B}Number of active caching plugins:${NC} ${Y}$(wp plugin list | grep -w 'active' | egrep 'cache|optimize|speed' | awk '{print $1}' | wc -l)"${NC}
space
echo -e "${B}Begin cache cleaning${NC}"
wp cache flush --skip-plugins --skip-themes
if [[ -n $(wp plugin list | grep -w 'active' | grep 'sg-cachepress') ]]
then
	wp sg purge --skip-themes
fi
wp rewrite flush
wp transient delete --expired
echo -e "${G}Success:${NC} Cache folder cleared" ; rm -rf wp-content/cache/*
echo -e "${G}Success:${NC} OpCache folder cleared" ; rm -rf ~/.opcache/*
if [[ -n $(wp plugin list | grep -w 'active' | grep 'elementor') ]]
then
	wp elementor flush_css --skip-themes
fi
echo -e "${G}Cache cleaned succesfully${NC}"

