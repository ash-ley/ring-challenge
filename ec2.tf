# SECURITY GROUP, 1 PUBLIC EC2, 5 PRIVATE EC2

resource "aws_security_group" "ring_sg" {
    name = "ring_sg"
    description = "Allow access to my servers"
    vpc_id = aws_vpc.main.id

  #Karolina
  ingress {
    description      = "SSH from my mac"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["31.205.63.101/32"]
  }

#Ashley
  ingress {
    description      = "SSH from my mac"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["86.21.150.205/32"]
  }

#Tahsin
  ingress {
    description      = "SSH from my mac"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["81.108.153.97/32"]
  }

#Himat
  ingress {
    description      = "SSH from my mac"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["77.99.152.53/32"]
  }

  #Mia
  ingress {
    description      = "SSH from my mac"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["72.74.153.243/32"]
  }

  #Pascal
  ingress {
    description      = "SSH from my mac"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["92.239.22.191/32"]
  }

    ingress {
        description      = "SSH from my VPC"
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = ["192.168.0.0/16"]
    }

    egress {
      description = "Allow access to the world"
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
      Name = "ring_sg"
  }
}

data "aws_ami" "my_aws_ami" {
    owners = ["137112412989"]
    most_recent = true
    filter {
        name = "name"
        values = [ "amzn2-ami-kernel-*" ]
    }
}

data "template_file" "user_data_public" {
    template = "${file("${path.cwd}/bootstrap-public.sh.tpl")}"
    vars = {
        private_key = data.local_file.private_key.content
        private_ip1 = aws_instance.private_servers.*.private_ip[0]
    }
}

data "template_file" "user_data_private" {
    template = "${file("${path.cwd}/bootstrap-private.sh.tpl")}"
    vars = {
        challenge_script = data.local_file.script.content
        private_key = data.local_file.private_key.content
    }
}

resource "aws_instance" "public_server" {
    ami = data.aws_ami.my_aws_ami.id
    instance_type = var.instance_type
    key_name = var.keypair_name
    subnet_id = aws_subnet.public.id
    user_data = "${data.template_file.user_data_public.rendered}"
    vpc_security_group_ids = [aws_security_group.ring_sg.id]

    tags = {
        Name = "public-ring"
    }
    depends_on = [
      aws_instance.private_servers
    ]
}

resource "aws_instance" "private_servers" {
    count = var.instance_count
    ami = data.aws_ami.my_aws_ami.id
    instance_type = var.instance_type
    key_name = var.keypair_name
    subnet_id = aws_subnet.private.id
    user_data = "${data.template_file.user_data_private.rendered}"
    vpc_security_group_ids = [aws_security_group.ring_sg.id]

    tags = {
        Name = "private-ring-${count.index + 1}"
    }
    depends_on = [
      aws_nat_gateway.nat
    ]
}