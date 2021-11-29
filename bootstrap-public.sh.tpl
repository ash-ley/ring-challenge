#!/bin/bash
cat <<EOF >> /home/ec2-user/.ssh/id_rsa
${private_key}
EOF
chown ec2-user:ec2-user /home/ec2-user/.ssh/id_rsa
chmod 600 /home/ec2-user/.ssh/id_rsa

echo "1" > /tmp/file
scp -o StrictHostKeyChecking=no -i /home/ec2-user/.ssh/id_rsa /tmp/file ${private_ip1}:/tmp/file