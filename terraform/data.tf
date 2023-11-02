data "aws_ami" "amazon_linux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
  owners = ["amazon"]
}

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

# for constraining access to own ip
data "http" "ip" {
  url = "https://ifconfig.me/ip"
}

# be able to get data about the current region
data "aws_region" "current" {}

