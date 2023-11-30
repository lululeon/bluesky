# for constraining access to own ip
data "http" "ip" {
  url = "https://ifconfig.me/ip"
}

# be able to get data about the current region
data "aws_region" "current" {}
