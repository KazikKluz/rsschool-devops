# Get latest AMI ID for Amazon Linux 2023
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet[0].id
  associate_public_ip_address = true

  key_name = var.ssh_key



  security_groups = [
    aws_security_group.allow_http_and_ssh.id
  ]

  tags = {
    Name = "RS Bastion Host"
  }
}

resource "aws_instance" "public-instance" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet[1].id
  associate_public_ip_address = true

  key_name = var.ssh_key



  security_groups = [
    aws_security_group.allow_http_and_ssh.id
  ]

  tags = {
    Name = "Public Instance 1"
  }
}

resource "aws_instance" "private-instance-1" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.private_subnet[0].id
  associate_public_ip_address = false

  key_name = var.ssh_key



  security_groups = [
    aws_security_group.allow_http_and_ssh.id
  ]

  tags = {
    Name = "Private Instance 1"
  }
}

resource "aws_instance" "private-instance-2" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.private_subnet[1].id
  associate_public_ip_address = false

  key_name = var.ssh_key



  security_groups = [
    aws_security_group.allow_http_and_ssh.id
  ]

  tags = {
    Name = "Private Instance 2"
  }
}