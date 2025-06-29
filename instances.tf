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
  ami                         = "ami-06fd44057cc9e8551" # a community NAT ready image from AWS
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet[0].id
  associate_public_ip_address = true
  source_dest_check           = false
  key_name                    = var.ssh_key


  security_groups = [
    aws_security_group.allow_http_and_ssh.id
  ]

  tags = {
    Name = "RS Bastion Host and NAT"
  }
}

# resource "aws_instance" "public-instance" {
#   ami                         = data.aws_ami.al2023.id
#   instance_type               = var.instance_type
#   subnet_id                   = aws_subnet.public_subnet[1].id
#   associate_public_ip_address = true
#
#   key_name = var.ssh_key
#
#
#
#   security_groups = [
#     aws_security_group.allow_http_and_ssh.id
#   ]
#
#   tags = {
#     Name = "Public Instance 1"
#   }
# }

resource "aws_instance" "k3s_server" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.private_subnet[0].id
  associate_public_ip_address = false

  key_name = var.ssh_key

  user_data = templatefile("k3s_server.sh", {
    token = var.token
  })

  depends_on = [aws_instance.bastion]


  vpc_security_group_ids = [

    aws_security_group.k3s_server_sg.id
  ]

  tags = {
    Name = "K3s Server"
  }
}

resource "aws_instance" "k3s_agent" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.private_subnet[1].id
  associate_public_ip_address = false

  key_name = var.ssh_key

  user_data = templatefile("k3s_agent.sh", {
    token       = var.token,
    server_addr = aws_instance.k3s_server.private_ip
  })

  depends_on = [aws_instance.k3s_server]

  vpc_security_group_ids = [
    aws_security_group.k3s_agent_sg.id
  ]

  tags = {
    Name = "K3s Agent"
  }
}
