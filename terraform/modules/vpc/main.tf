# Create a VPC
resource "aws_vpc" "main" {
  cidr_block           = var.cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Environment = var.environment
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.publicCIDR
  availability_zone = var.availability_zone

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "public1_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public1CIDR
  availability_zone = var.availability1_zone

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.privateCIDR
  availability_zone = var.availability_zone

  tags = {
    Name = "private-subnet"
  }
}

resource "aws_subnet" "private1_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private1CIDR
  availability_zone = var.availability1_zone

  tags = {
    Name = "private1-subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.environment
  }
}

resource "aws_route_table" "internet_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = var.environment
  }
}

resource "aws_route_table_association" "internet_rta_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.internet_rt.id
}


resource "aws_security_group" "main_security_group" {
  name        = var.security_group_name
  description = var.security_group_description  
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private_subnet_security_group" {
  name        = var.private_subnet_security_group_name
  description = var.private_subnet_security_group_description  
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = var.private_subnet_allowed_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # egress {
  # from_port   = 443
  # to_port     = 443
  # protocol    = "tcp"
  # cidr_blocks = ["0.0.0.0/0"]
  # }

}

# resource "aws_eip" "nat" {
#   domain = "vpc"
# }

# resource "aws_nat_gateway" "main" {
#   allocation_id = aws_eip.nat.id
#   subnet_id     = aws_subnet.public_subnet.id
# }


resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  # route {
  #   cidr_block     = "0.0.0.0/0"
  #   nat_gateway_id = aws_nat_gateway.main.id
  # }

  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private1_subnet.id
  route_table_id = aws_route_table.private_rt.id
}


resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.us-east-1.ecr.dkr"
  vpc_endpoint_type = "Interface"
  subnet_ids   = [aws_subnet.private1_subnet.id]
  security_group_ids = [aws_security_group.private_subnet_security_group.id]
  private_dns_enabled = true
}


resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.us-east-1.ecr.api"
  vpc_endpoint_type = "Interface"
  subnet_ids   = [aws_subnet.private1_subnet.id]
  security_group_ids = [aws_security_group.private_subnet_security_group.id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.us-east-1.s3"
  route_table_ids = [aws_route_table.private_rt.id]
  tags = {
    Name = "s3-endpoint"
  }
}
