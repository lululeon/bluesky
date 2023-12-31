
# firewall
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"
  vpc_id      = data.terraform_remote_state.layer1.outputs.vpc_id

  # allow from public_a only
  ingress {
    description = "SSH from VPC public subnets"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = data.terraform_remote_state.layer1.outputs.public_cidrs
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    { "Name" = "${local.prefix}_allow_ssh_a" }
  )
}

resource "aws_network_interface" "ubuntu_nic_a" {
  subnet_id       = data.terraform_remote_state.layer1.outputs.private_subnet0_id
  security_groups = [aws_security_group.allow_ssh.id]

  tags = merge(
    local.common_tags,
    { "Name" = "${local.prefix}_ubuntu_nic_a" }
  )
}

resource "aws_instance" "ubuntu_a" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = local.pubkey

  network_interface {
    network_interface_id = aws_network_interface.ubuntu_nic_a.id
    device_index         = 0
  }

  tags = merge(
    local.common_tags,
    { "Name" = "${local.prefix}_ubuntu_a" }
  )
}
