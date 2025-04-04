resource "aws_subnet" "public-subnet" {

  count             = length(var.public_cird_block)
  vpc_id            = aws_vpc.default.id
  cidr_block        = element(var.public_cird_block, count.index + 1)
  availability_zone = element(var.azs, count.index)


  tags = {
    Name        = "${var.vpc_name}-public-subnet-${count.index + 1}"
    Owner       = local.Owner
    costCenter  = local.costCenter
    TeamDL      = local.TeamDL
    environment = "${var.environment}"
  }
}
