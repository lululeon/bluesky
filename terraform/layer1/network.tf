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


resource "aws_internet_gateway" "main" {
  # lives in the vpc just created above
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    { "Name" = "${local.prefix}_main" }
  )
}



#########################################################################################################
#                            Public Subnet Resources
#########################################################################################################

resource "aws_subnet" "public" {
  count = local.num_public_subnets

  cidr_block = local.public_cidrs[count.index]
  vpc_id     = aws_vpc.main.id

  # as soon as anything is provisioned on this net, assign it a publicly reachable ip address
  map_public_ip_on_launch = true

  availability_zone = "${data.aws_region.current.name}${local.zones[count.index]}"

  # wait for gw
  depends_on = [aws_internet_gateway.main]

  tags = merge(
    local.common_tags,
    { "Name" = "${local.prefix}_public_${local.zones[count.index]}" }
  )
}

resource "aws_route_table" "public" {
  count  = local.num_public_subnets
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    { "Name" = "${local.prefix}_public_${local.zones[count.index]}" }
  )
}

# links the routing table created above to the subnet
resource "aws_route_table_association" "public" {
  count          = local.num_public_subnets
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[count.index].id
}

# add a route that makes everything in the subnet accessible to the internet
resource "aws_route" "public_internet_route" {
  count                  = local.num_public_subnets
  route_table_id         = aws_route_table.public[count.index].id
  gateway_id             = aws_internet_gateway.main.id
  destination_cidr_block = "0.0.0.0/0"
}

# Need a NAT gateway (egress only) for entities walled off
# in our private subnet (not defined yet). Each NAT gw must be in a *public* subnet.
# They also need an ip each, so we need to first create one using elastic ip
resource "aws_eip" "public" {
  count = local.num_public_subnets

  # this ip exists inside a vpc
  domain = "vpc"

  # wait for gw: must be in place before eip can be instantiated
  depends_on = [aws_internet_gateway.main]

  tags = merge(
    local.common_tags,
    { "Name" = "${local.prefix}_public_${local.zones[count.index]}" }
  )
}

resource "aws_nat_gateway" "public" {
  count         = local.num_public_subnets
  allocation_id = aws_eip.public[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(
    local.common_tags,
    { "Name" = "${local.prefix}_public_${local.zones[count.index]}" }
  )
}


#########################################################################################################
#                            Private Subnet Resources
#########################################################################################################

resource "aws_subnet" "private" {
  count = local.num_private_subnets

  cidr_block = local.private_cidrs[count.index]

  vpc_id = aws_vpc.main.id

  availability_zone = "${data.aws_region.current.name}${local.zones[count.index]}"

  # wait for gw
  depends_on = [aws_internet_gateway.main]

  tags = merge(
    local.common_tags,
    { "Name" = "${local.prefix}_private_${local.zones[count.index]}" }
  )
}

resource "aws_route_table" "private" {
  count  = local.num_private_subnets
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    { "Name" = "${local.prefix}_private_${local.zones[count.index]}" }
  )
}

resource "aws_route_table_association" "private" {
  count          = local.num_private_subnets
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# add the egress-only route that lets private subnet reach the internet:
resource "aws_route" "private_internet_route" {
  count          = local.num_private_subnets
  route_table_id = aws_route_table.private[count.index].id

  # instead of an internet 'gateway_id' here, we specify the relevant NAT gateway instead:
  nat_gateway_id         = aws_nat_gateway.public[count.index].id
  destination_cidr_block = "0.0.0.0/0"
}
