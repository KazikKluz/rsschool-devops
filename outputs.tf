output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "k3s_server_ip" {
  value = aws_instance.k3s_server.private_ip
}

output "k3s_agent_ip" {
  value = aws_instance.k3s_agent.private_ip
}

# testing pipeline
