#!/bin/bash
cat <<EOF >> /home/ec2-user/.ssh/id_rsa
${private_key}
EOF
chown ec2-user:ec2-user /home/ec2-user/.ssh/id_rsa
chmod 600 /home/ec2-user/.ssh/id_rsa

ssh -i /home/ec2-user/.ssh/id_rsa ${private_ip1} bash -c "nohup watch -n 15 --precise /home/ec2-user/script.sh >/dev/null &"
ssh -i /home/ec2-user/.ssh/id_rsa ${private_ip2} bash -c "nohup watch -n 15 --precise /home/ec2-user/script.sh >/dev/null &"
ssh -i /home/ec2-user/.ssh/id_rsa ${private_ip3} bash -c "nohup watch -n 15 --precise /home/ec2-user/script.sh >/dev/null &"
ssh -i /home/ec2-user/.ssh/id_rsa ${private_ip4} bash -c "nohup watch -n 15 --precise /home/ec2-user/script.sh >/dev/null &"
ssh -i /home/ec2-user/.ssh/id_rsa ${private_ip5} bash -c "nohup watch -n 15 --precise /home/ec2-user/script.sh >/dev/null &"