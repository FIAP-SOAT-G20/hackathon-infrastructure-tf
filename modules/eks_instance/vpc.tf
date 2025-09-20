data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "hackathon_vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.tags, {
    Name = "${var.project_name}-vpc"
  })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.hackathon_vpc.id

  tags = merge(var.tags, {
    Name = "${var.project_name}-igw"
  })
}

resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.hackathon_vpc.id
  cidr_block              = cidrsubnet(var.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.project_name}-public-${count.index + 1}"
    Type = "Public"
  })
}

resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.hackathon_vpc.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, count.index + 10)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(var.tags, {
    Name = "${var.project_name}-private-${count.index + 1}"
    Type = "Private"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.hackathon_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-public-rt"
  })
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Elastic IP para o NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = merge(var.tags, {
    Name = "${var.project_name}-nat-eip"
  })
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(var.tags, {
    Name = "${var.project_name}-nat"
  })
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.hackathon_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-private-rt"
  })
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
