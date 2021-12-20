#!/bin/bash

apps=$(find ~/ -name wp-config.php 2>/dev/null | sed 's/\/wp-config.php//g' )

for app in $apps
do
	echo "Path: $app"
	echo "-------------"
	echo "Name of App: $(wp option get blogname --path=$app --skip-plugins --skip-themes)"
	echo "Database Name: $(wp config get DB_NAME --path=$app)" 
	echo "Database User: $(wp config get DB_USER --path=$app)"
	echo "Databse Password: $(wp config get DB_PASSWORD --path=$app)"
	echo "=============="
done
