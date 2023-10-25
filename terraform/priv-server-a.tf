data "aws_ami" "ubuntu" {
  most_recent = true

  # from terraform docs example lookup
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/virtualization_types.html
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical (ubuntu)
}


# firewall
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.main.id

  # allow from public_a only
  ingress {
    description = "SSH from VPC public subnets"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.private_a.cidr_block]
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.private_a.cidr_block]
  }

  tags = merge(
    local.common_tags,
    { "Name" = "${local.prefix}-allow-ssh-a" }
  )
}

resource "aws_network_interface" "ubuntu-nic-a" {
  subnet_id       = aws_subnet.private_a.id
  security_groups = [aws_security_group.allow_ssh.id]

  tags = merge(
    local.common_tags,
    { "Name" = "${local.prefix}-ubuntu-nic-a" }
  )
}

resource "aws_instance" "ubuntu-a" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = local.pubkey

  network_interface {
    network_interface_id = aws_network_interface.ubuntu-nic-a.id
    device_index         = 0
  }

  tags = merge(
    local.common_tags,
    { "Name" = "${local.prefix}-ubuntu-a" }
  )
}
