#######################################################################################################
# VPC resources: This will create the first VPC with 4 Subnets, 1 Internet Gateway, 4 Route Tables.  #
####################################################################################################### 

resource "aws_vpc" "first_vpc" {
  cidr_block           = var.first_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  
  tags      = {
    Name    =  "first_vpc"
  }
}

resource "aws_internet_gateway" "first_vpc_gateway" {
  vpc_id = aws_vpc.first_vpc.id
  tags      = {
    Name    = "First VPC IGW"
  }
}

resource "aws_route_table" "first_vpc_private" {
  count = length(var.first_private_subnet_cidr_blocks)

  vpc_id = aws_vpc.first_vpc.id
  tags      = {
    Name    = "First VPC Private Route Table"
  }
}

resource "aws_route" "first_vpc_private" {
  count = length(var.first_private_subnet_cidr_blocks)

  route_table_id         = aws_route_table.first_vpc_private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.first_vpc[count.index].id
  
}

resource "aws_route_table" "first_vpc_public" {
  vpc_id = aws_vpc.first_vpc.id
  tags      = {
    Name    = "First VPC Pubic Route Table"
  }
}

resource "aws_route" "first_vpc_public" {
  route_table_id         = aws_route_table.first_vpc_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.first_vpc_gateway.id
   
}

resource "aws_subnet" "first_vpc_private" {
  count = length(var.first_private_subnet_cidr_blocks)

  vpc_id            = aws_vpc.first_vpc.id
  cidr_block        = var.first_private_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones_first[count.index]
  tags      = {
    Name    = "First VPC Private Subnet"
  }
}

resource "aws_subnet" "first_vpc_public" {
  count = length(var.first_public_subnet_cidr_blocks)

  vpc_id                  = aws_vpc.first_vpc.id
  cidr_block              = var.first_public_subnet_cidr_blocks[count.index]
  availability_zone       = var.availability_zones_first[count.index]
  map_public_ip_on_launch = true
  tags      = {
    Name    = "First VPC Public Subnet"
  }
}

resource "aws_route_table_association" "first_vpc_private" {
  count = length(var.first_private_subnet_cidr_blocks)

  subnet_id      = aws_subnet.first_vpc_private[count.index].id
  route_table_id = aws_route_table.first_vpc_private[count.index].id
}

resource "aws_route_table_association" "first_vpc_public" {
  count = length(var.first_public_subnet_cidr_blocks)

  subnet_id      = aws_subnet.first_vpc_public[count.index].id
  route_table_id = aws_route_table.first_vpc_public.id
}


# NAT resources: This will create 2 NAT gateways in 2 Public Subnets for 2 different Private Subnets.

resource "aws_eip" "first_vpc_nat" {
  count = length(var.first_public_subnet_cidr_blocks)

  vpc = true
}

resource "aws_nat_gateway" "first_vpc" {
  depends_on = [aws_internet_gateway.first_vpc_gateway]

  count = length(var.first_public_subnet_cidr_blocks)

  allocation_id = aws_eip.first_vpc_nat[count.index].id
  subnet_id     = aws_subnet.first_vpc_public[count.index].id
}


#######################################################################################################
# VPC resources: This will create the second VPC with 4 Subnets, 1 Internet Gateway, 4 Route Tables.  #
#######################################################################################################



resource "aws_vpc" "second_vpc" {
  cidr_block           = var.second_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  
  tags      = {
    Name    =  "second_vpc"
  }
}

resource "aws_internet_gateway" "second_vpc_gateway" {
  vpc_id = aws_vpc.second_vpc.id
  tags      = {
    Name    = "Second VPC IGW"
  }
}

resource "aws_route_table" "second_vpc_private" {
  count = length(var.second_private_subnet_cidr_blocks)

  vpc_id = aws_vpc.second_vpc.id
  tags      = {
    Name    = "Second VPC Private Route Table"
  }
}

resource "aws_route" "second_vpc_private" {
  count = length(var.second_private_subnet_cidr_blocks)

  route_table_id         = aws_route_table.second_vpc_private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.second_vpc[count.index].id
   
}

resource "aws_route_table" "second_vpc_public" {
  vpc_id = aws_vpc.second_vpc.id
  tags      = {
    Name    = "Second VPC Public Route Table"
  }
}

resource "aws_route" "second_vpc_public" {
  route_table_id         = aws_route_table.second_vpc_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.second_vpc_gateway.id
  
}

resource "aws_subnet" "second_vpc_private" {
  count = length(var.second_private_subnet_cidr_blocks)

  vpc_id            = aws_vpc.second_vpc.id
  cidr_block        = var.second_private_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones_second[count.index]
  tags      = {
    Name    = "Second VPC Private subnet"
  }
}

resource "aws_subnet" "second_vpc_public" {
  count = length(var.second_public_subnet_cidr_blocks)

  vpc_id                  = aws_vpc.second_vpc.id
  cidr_block              = var.second_public_subnet_cidr_blocks[count.index]
  availability_zone       = var.availability_zones_second[count.index]
  map_public_ip_on_launch = true
  tags      = {
    Name    = "Second VPC Public subnet"
  }
}

resource "aws_route_table_association" "second_vpc_private" {
  count = length(var.second_private_subnet_cidr_blocks)

  subnet_id      = aws_subnet.second_vpc_private[count.index].id
  route_table_id = aws_route_table.second_vpc_private[count.index].id
}

resource "aws_route_table_association" "second_vpc_public" {
  count = length(var.second_public_subnet_cidr_blocks)

  subnet_id      = aws_subnet.second_vpc_public[count.index].id
  route_table_id = aws_route_table.second_vpc_public.id
}


# NAT resources: This will create 2 NAT gateways in 2 Public Subnets for 2 different Private Subnets.

resource "aws_eip" "second_vpc_nat" {
  count = length(var.second_public_subnet_cidr_blocks)

  vpc = true
}

resource "aws_nat_gateway" "second_vpc" {
  depends_on = [aws_internet_gateway.second_vpc_gateway]

  count = length(var.second_public_subnet_cidr_blocks)

  allocation_id = aws_eip.second_vpc_nat[count.index].id
  subnet_id     = aws_subnet.second_vpc_public[count.index].id
}