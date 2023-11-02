
resource "aws_security_group" "bastion" {
  description = "control bastion network traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    # second cidr is requisite AWS ip ranges used for browser-based SSH connections (at last check)
    cidr_blocks = ["${local.own_ip}/32", "18.206.107.24/29"]
  }

  egress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    { "Name" = "${local.prefix}_bastion" }
  )
}


resource "aws_eip" "bastion" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.main]

  tags = merge(
    local.common_tags,
    { "Name" = "${local.prefix}_bastion" }
  )
}

resource "aws_instance" "bastion" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.nano"

  key_name  = var.bastion_keyname
  subnet_id = aws_subnet.public[0].id
  vpc_security_group_ids = [
    aws_security_group.bastion.id
  ]

  tags = merge(
    local.common_tags,
    { "Name" = "${local.prefix}_bastion" }
  )
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.bastion.id
  allocation_id = aws_eip.bastion.id
}
