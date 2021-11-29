#!/bin/bash

FILE=/tmp/file
KEY=/home/ec2-user/.ssh/id_rsa

if ! command -v nmap &> /dev/null
then
    sudo yum install -y nmap
fi

if test -f "\$FILE"; then
   # Read file and increment the number
	num=\$(cat \$FILE)
	num=\$((num+=1))
	echo \$num > \$FILE
    # Find the next server to send it to
    	MYIP=\$(ifconfig eth0 | awk '\$1 == "inet" {print \$2}')
    	IP=\$(nmap --exclude \$MYIP -Pn -p22 --open \$MYIP-254 -oG - | awk '/Up\$/{print \$2}' | head -n 1)
	if [ -z "\${IP}" ]; then
		IP=\$(nmap --exclude \$MYIP -Pn -p22 --open 192.168.25.4-\$MYIP | awk 'Up\$/{print \$2}' | head -n 1)
	fi
    # send the file
    scp -o StrictHostKeyChecking=no -i \$KEY \$FILE \$IP:\$FILE
	#rm \$FILE
	
fi
