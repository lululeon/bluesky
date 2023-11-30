output "prefix" {
  value = local.prefix
}

output "common_tags" {
  value = local.common_tags
}

output "own_ip" {
  value = local.own_ip
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "igw" {
  value = aws_internet_gateway.main
}

output "private_subnet0_id" {
  value = aws_subnet.private[0].id
}

output "public_subnet0_id" {
  value = aws_subnet.public[0].id
}

output "public_cidrs" {
  value = local.public_cidrs
}
