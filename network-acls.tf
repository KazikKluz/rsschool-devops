resource "aws_network_acl" "rs_acl" {
  vpc_id = aws_vpc.rs_vpc.id
  tags = {
    Name = "RS NACL"
  }
}

# Allow inbound HTTP (port 80)
resource "aws_network_acl_rule" "allow_http_inbound" {
  network_acl_id = aws_network_acl.rs_acl.id
  rule_number    = 100
  protocol       = "tcp"
  rule_action    = "allow"
  egress         = false
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

resource "aws_network_acl_rule" "allow_https_inbound" {
  network_acl_id = aws_network_acl.rs_acl.id
  rule_number    = 101
  protocol       = "tcp"
  rule_action    = "allow"
  egress         = false
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

# Allow inbound SSH (port 22)
resource "aws_network_acl_rule" "allow_ssh_inbound" {
  network_acl_id = aws_network_acl.rs_acl.id
  rule_number    = 102
  protocol       = "tcp"
  rule_action    = "allow"
  egress         = false
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}

# Allow all inbound ICMP
resource "aws_network_acl_rule" "allow_ping_inbound" {
  network_acl_id = aws_network_acl.rs_acl.id
  rule_number    = 103
  protocol       = "-1" // All protocols
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  icmp_type      = "-1" // All ICMP types
  icmp_code      = "-1" // All ICMP codes
}

# Deny all other inbound traffic
resource "aws_network_acl_rule" "deny_all_inbound" {
  network_acl_id = aws_network_acl.rs_acl.id
  rule_number    = 200
  protocol       = "-1" # -1 means all protocols
  rule_action    = "deny"
  egress         = false
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

# Allow all outbound traffic
resource "aws_network_acl_rule" "allow_all_outbound" {
  network_acl_id = aws_network_acl.rs_acl.id
  rule_number    = 300
  protocol       = "-1"
  rule_action    = "allow"
  egress         = true
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_association" "acl_assoc_public" {
  count          = length(var.public_cidrs)
  subnet_id      = element(aws_subnet.public_subnet[*].id, count.index)
  network_acl_id = aws_network_acl.rs_acl.id
}

resource "aws_network_acl_association" "acl_assoc_private" {
  count          = length(var.private_cidrs)
  subnet_id      = element(aws_subnet.private_subnet[*].id, count.index)
  network_acl_id = aws_network_acl.rs_acl.id
}