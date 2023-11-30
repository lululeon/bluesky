
resource "aws_security_group" "web_server" {
  description = "control web_server network traffic"
  vpc_id      = data.terraform_remote_state.layer1.outputs.vpc_id

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

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    { "Name" = "${local.prefix}_web_server" }
  )
}


resource "aws_eip" "web_server" {
  domain = "vpc"

  tags = merge(
    local.common_tags,
    { "Name" = "${local.prefix}_web_server" }
  )
}

resource "aws_iam_role" "web_server" {
  name               = "${local.prefix}_web_server"
  assume_role_policy = file("./files/webserver-assume-role.json")
  tags = merge(
    local.common_tags,
    { "Name" = "${local.prefix}_web_server" }
  )
}

resource "aws_iam_role_policy_attachment" "web_server_attach_policy" {
  role       = aws_iam_role.web_server.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "web_server" {
  name = "${local.prefix}_web_server_instance_profile"
  role = aws_iam_role.web_server.name
  tags = merge(
    local.common_tags,
    { "Name" = "${local.prefix}_web_server" }
  )
}

resource "aws_instance" "web_server" {
  ami                  = data.aws_ami.amazon_linux.id
  instance_type        = "t2.nano"
  user_data            = templatefile("./files/userdata-webserver.tftpl", { region = local.region, accountnum = local.accountnum, image = local.image })
  iam_instance_profile = aws_iam_instance_profile.web_server.name

  key_name  = local.pubkey
  subnet_id = data.terraform_remote_state.layer1.outputs.public_subnet0_id
  vpc_security_group_ids = [
    aws_security_group.web_server.id
  ]

  tags = merge(
    local.common_tags,
    { "Name" = "${local.prefix}_web_server" }
  )
}

resource "aws_eip_association" "eip_assoc_web_server" {
  instance_id   = aws_instance.web_server.id
  allocation_id = aws_eip.web_server.id
}

