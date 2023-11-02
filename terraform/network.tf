#####################################################
# Main network
#####################################################
resource "aws_vpc" "main" {
  # ppl usually set for max number of hosts (>65K addresses)
  cidr_block = "10.1.0.0/16"

  enable_dns_support = true

  # friendly hostnames!
  enable_dns_hostnames = true

  tags = merge(
    local.common_tags,
    { "Name" = "${local.prefix}_vpc" }
  )
}


# impl public internet access
resource "aws_internet_gateway" "main" {
  # lives in the vpc just created above
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    { "Name" = "${local.prefix}_main" }
  )
}



#########################################################################################################
#                            Public Subnets
#########################################################################################################

###################################
# ----------- A Subnet ------------
###################################

resource "aws_subnet" "public_a" {
  # up to 254 hosts (always a number of addresses reserved by aws)
  cidr_block = "10.1.1.0/24"

  vpc_id = aws_vpc.main.id

  # as soon as anything is provisioned on this net, assign it a publicly reachable ip address
  map_public_ip_on_launch = true

  availability_zone = "${data.aws_region.current.name}a"

  # wait for gw
  depends_on = [aws_internet_gateway.main]

  tags = merge(
    local.common_tags,
    { "Name" = "${local.prefix}_public_a" }
  )
}

resource "aws_route_table" "public_a" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    { "Name" = "${local.prefix}_public_a" }
  )
}

# links the routing table created above to the subnet
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_a.id
}

# add a route that makes everything in the subnet accessible to the internet
resource "aws_route" "public_internet_access_a" {
  route_table_id         = aws_route_table.public_a.id
  gateway_id             = aws_internet_gateway.main.id
  destination_cidr_block = "0.0.0.0/0"
}

# Need a NAT gateway (egress only) for entities walled off
# in our private subnet (not defined yet). The NAT gw must be in the *public* subnet.
# It also needs an ip, so we need to first create one using elastic ip
resource "aws_eip" "public_a" {
  # this ip exists inside a vpc
  domain = "vpc"

  # wait for gw: must be in place before eip can be instantiated
  depends_on = [aws_internet_gateway.main]

  tags = merge(
    local.common_tags,
    { "Name" = "${local.prefix}_public_a" }
  )
}

resource "aws_nat_gateway" "public_a" {
  allocation_id = aws_eip.public_a.id
  subnet_id     = aws_subnet.public_a.id

  tags = merge(
    local.common_tags,
    { "Name" = "${local.prefix}_public_a" }
  )
}

###################################
# ----------- B Subnet ------------
###################################

resource "aws_subnet" "public_b" {
  cidr_block              = "10.1.2.0/24"
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true

  availability_zone = "${data.aws_region.current.name}b"

  depends_on = [aws_internet_gateway.main]

  tags = merge(
    local.common_tags,
    { "Name" = "${local.prefix}_public_b" }
  )
}

resource "aws_route_table" "public_b" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    { "Name" = "${local.prefix}_public_b" }
  )
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public_b.id
}

resource "aws_route" "public_internet_access_b" {
  route_table_id         = aws_route_table.public_b.id
  gateway_id             = aws_internet_gateway.main.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_eip" "public_b" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.main]

  tags = merge(
    local.common_tags,
    { "Name" = "${local.prefix}_public_b" }
  )
}

resource "aws_nat_gateway" "public_b" {
  allocation_id = aws_eip.public_b.id
  subnet_id     = aws_subnet.public_b.id

  tags = merge(
    local.common_tags,
    { "Name" = "${local.prefix}_public_b" }
  )
}



#########################################################################################################
#                            Private Subnets
#########################################################################################################
###################################
# ------ Privat A Subnet ----------
###################################
resource "aws_subnet" "private_a" {
  # our network might grow: leave 10.1 through 10.9 to extra public subnets.
  cidr_block = "10.1.10.0/24"

  vpc_id = aws_vpc.main.id

  availability_zone = "${data.aws_region.current.name}a"

  # wait for gw
  depends_on = [aws_internet_gateway.main]

  tags = merge(
    local.common_tags,
    { "Name" = "${local.prefix}_private_a" }
  )
}

resource "aws_route_table" "private_a" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    { "Name" = "${local.prefix}_private_a" }
  )
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_a.id
}

# add the egress-only route that lets private subnet reach the internet:
resource "aws_route" "private_a_internet_out" {
  route_table_id = aws_route_table.private_a.id

  # instead of an internet 'gateway_id' here, we specify the relevant NAT gateway instead:
  nat_gateway_id         = aws_nat_gateway.public_a.id
  destination_cidr_block = "0.0.0.0/0"
}

###################################
# ------ Private B Subnet ---------
###################################
resource "aws_subnet" "private_b" {
  # our network might grow: leave 10.1 through 10.9 to extra public subnets.
  cidr_block = "10.1.11.0/24"

  vpc_id = aws_vpc.main.id

  availability_zone = "${data.aws_region.current.name}b"

  # wait for gw
  depends_on = [aws_internet_gateway.main]

  tags = merge(
    local.common_tags,
    { "Name" = "${local.prefix}_private_b" }
  )
}

resource "aws_route_table" "private_b" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    { "Name" = "${local.prefix}_private_b" }
  )
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private_b.id
}

# add the egress-only route that lets private subnet reach the internet:
resource "aws_route" "private_b_internet_out" {
  route_table_id = aws_route_table.private_b.id

  # instead of an internet 'gateway_id' here, we specify the relevant NAT gateway instead:
  nat_gateway_id         = aws_nat_gateway.public_b.id
  destination_cidr_block = "0.0.0.0/0"
}
