#!/bin/bash

echo "Input Hostname:"
while [[ -z $hostname_in ]]
do
	read hostname_in
done
hostname=$(echo $hostname_in | awk '{print $2}')

echo "Input Username:"
while [[ -z $username_in ]]
do
	read username_in
done
username=$(echo $username_in | awk '{print $2}')

echo "ssh -o StrictHostKeyChecking=no $username@$hostname -p18765" >> ~/Desktop/scripts/.ssh_log
ssh -o StrictHostKeyChecking=no $username@$hostname -p18765
