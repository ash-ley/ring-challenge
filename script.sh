#!/bin/bash

FILE=/tmp/file
KEY=/home/.ssh/key.pem

if ! command -v nmap &> /dev/null
then
    sudo yum install -y nmap
fi

if test -f "$FILE"; then
   # Read file and increment the number
	num=$(cat $FILE)
	num=$((num+=1))
	echo $num > $FILE
    # Find the next server to send it to
    	MYIP=$(ifconfig eth0 | awk '$1 == "inet" {print $2}')
    	IP=$(nmap -n -sn $MYIP-254 -oG - | awk '/Up$/{print $2}' | head -n 1)
	if [ -z "${IP}" ]; then
		IP=$(nmap -n -sn 192.168.25.4-$MYIP | awk 'Up$/{print $2}' | head -n 1)
	fi
    # send the file
    	if [ $IP -ne $MYIP ]; then
    		scp -i $KEY $FILE $IP:$FILE
		#rm $FILE
	fi
fi
