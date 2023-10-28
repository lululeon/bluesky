data "aws_ami" "amazon_linux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
  owners = ["amazon"]
}

# Policy that lets the EC2 service itself sts:AssumeRole, in order to set up the bastion with the right instance role, via aws_iam_policy_document
# (not used)

# Create and attach any other policies to the target role, via aws_iam_role_policy_attachment here:
# (not used)

# Create the instance profile via aws_iam_instance_profile (attached in aws_instance)
# (not used)

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
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    # cidr_blocks = ["${local.own_ip}/32", "18.206.107.24/29"]
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    { "Name" = "${local.prefix}-bastion" }
  )
}


resource "aws_eip" "bastion" {
  # this ip exists inside a vpc
  domain     = "vpc"
  depends_on = [aws_internet_gateway.main]

  tags = merge(
    local.common_tags,
    { "Name" = "${local.prefix}-bastion" }
  )
}

resource "aws_instance" "bastion" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.nano"

  # iam_instance_profile = aws_iam_instance_profile.bastion.name
  key_name  = var.bastion_keyname
  subnet_id = aws_subnet.public_a.id
  vpc_security_group_ids = [
    aws_security_group.bastion.id
  ]

  tags = merge(
    local.common_tags,
    { "Name" = "${local.prefix}-bastion" }
  )
}

# assign ip addr
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.bastion.id
  allocation_id = aws_eip.bastion.id
}
