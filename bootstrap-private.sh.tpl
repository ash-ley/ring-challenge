#!/bin/bash
sudo yum install -y nmap
cat <<EOF >> /home/ec2-user/script.sh
${challenge_script}
EOF
chown ec2-user:ec2-user /home/ec2-user/script.sh
chmod +x /home/ec2-user/script.sh

cat <<EOT >> /home/ec2-user/.ssh/id_rsa
${private_key}
EOT
chown ec2-user:ec2-user /home/ec2-user/.ssh/id_rsa
chmod 600 /home/ec2-user/.ssh/id_rsa

crontab -l > mycron
echo "* * * * * /home/ec2-user/script.sh" >> mycron
crontab mycron