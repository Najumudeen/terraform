resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.default.id

  route = {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }

  tags = {
    Name        = "${var.vpc_name}-Public-RT"
    Owner       = local.Owner
    costCenter  = local.costCenter
    TeamDL      = local.TeamDL
    environment = "${var.environment}"
  }
}

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.default.id

  route = {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }

  tags = {
    Name        = "${var.vpc_name}-private-RT"
    Owner       = local.Owner
    costCenter  = local.costCenter
    TeamDL      = local.TeamDL
    environment = "${var.environment}"
  }
}


resource "aws_route_table_association" "public-subnets" {

  count          = length(var.public_cird_block)
  subnet_id      = element(aws_subnet.public-subnet.*.id, count.index)
  route_table_id = aws_route_table.public-route-table.id

}

resource "aws_route_table_association" "private-subnets" {

  count          = length(var.private_cird_block)
  subnet_id      = element(aws_subnet.private-subnet.*.id, count.index)
  route_table_id = aws_route_table.private-route-table.id

}
