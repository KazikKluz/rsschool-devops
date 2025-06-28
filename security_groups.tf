resource "aws_security_group" "allow_http_and_ssh" {
  name        = "allow_http_and_ssh"
  description = "Allow for HTTP, HTTPS and SSH traffic"
  vpc_id      = aws_vpc.rs_vpc.id

  tags = {
    Name = "RS HTTP & SSH"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.allow_http_and_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.allow_http_and_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.allow_http_and_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_ping" {
  security_group_id = aws_security_group.allow_http_and_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = -1
  ip_protocol       = "icmp"
  to_port           = -1
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.allow_http_and_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_security_group" "k3s_server_sg" {
  description = "Security group for k3s Server Instance Located in a Private Subnet 1"
  vpc_id      = aws_vpc.rs_vpc.id
  name        = "k3s_server_instance_sg"
  tags = {
    Name = "k3s Server Instance Security Group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress_ssh_k3s_server" {
  security_group_id = aws_security_group.k3s_server_sg.id
  cidr_ipv4         = var.vpc_cidr_block
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"

}

resource "aws_vpc_security_group_ingress_rule" "ingress_6443_k3s_server" {
  security_group_id = aws_security_group.k3s_server_sg.id
  cidr_ipv4         = var.vpc_cidr_block
  from_port         = 6443
  to_port           = 6443
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "ingress_flannel_k3s_server" {
  security_group_id = aws_security_group.k3s_server_sg.id
  cidr_ipv4         = var.vpc_cidr_block
  from_port         = 8472
  to_port           = 8472
  ip_protocol       = "udp"
}

resource "aws_vpc_security_group_ingress_rule" "ingress_metrics_k3s_server" {
  security_group_id = aws_security_group.k3s_server_sg.id
  cidr_ipv4         = var.vpc_cidr_block
  from_port         = 10250
  to_port           = 10250
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "egress_any_k3s_server" {
  security_group_id = aws_security_group.k3s_server_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1"
}

resource "aws_security_group" "k3s_agent_sg" {
  description = "Security group for k3s Agent Instance Located in a Private Subnet 2"
  vpc_id      = aws_vpc.rs_vpc.id
  name        = "k3s_agent_instance_sg"
  tags = {
    Name = "k3s Agent Instance Security Group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress_ssh_k3s_agent" {
  security_group_id = aws_security_group.k3s_agent_sg.id
  cidr_ipv4         = var.vpc_cidr_block
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "ingress_flannel_k3s_agent" {
  security_group_id = aws_security_group.k3s_agent_sg.id
  cidr_ipv4         = var.vpc_cidr_block
  from_port         = 8472
  to_port           = 8472
  ip_protocol       = "udp"
}

resource "aws_vpc_security_group_ingress_rule" "ingress_metrics_k3s_agent" {
  security_group_id = aws_security_group.k3s_agent_sg.id
  cidr_ipv4         = var.vpc_cidr_block
  from_port         = 10250
  to_port           = 10250
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "egress_any_k3s_agent" {
  security_group_id = aws_security_group.k3s_agent_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1"
}
