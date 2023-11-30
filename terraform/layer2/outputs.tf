output "bastion_ip" {
  value = aws_eip.bastion.public_ip
}

output "web_server_ip" {
  value = aws_eip.web_server.public_ip
}
