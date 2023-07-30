resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
      var.tags,
      {
        Name = "Time-Internet-Gateway"
      }
    )

  # tags = {
  #     Name = "${var.Project_name}-Internet-Gateway"
  #     Terraform = true
  #     Environment = "Dev"
  # }
}

resource "aws_vpc" "vpc"{
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = merge(
      var.tags,
      {
        Name = "Time-vpc"
      }
    )

        
    # tags = {
    #     Name = "${var.Project_name}-vpc"
    #     Terraform = true
    #     Environment = "Dev"
    # }
}

resource "aws_subnet" "Public" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"

  tags = merge(
    var.tags,
    {
      Name = "Time-Public-subnet"
    }
  )

  # tags = {
  #       Name = "${var.Project_name}-public-subnet"
  #       Terraform = true
  #       Environment = "Dev"
  # }
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.vpc.id

    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = merge(
    var.tags,
    {
      Name = "Time-public-rt"
    }
  )

  # tags = {
  #       Name = "${var.Project_name}-public-route-table"
  #       Terraform = true
  #       Environment = "Dev"
  # }


}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.Public.id
  route_table_id = aws_route_table.public.id
}





resource "aws_subnet" "Private" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.11.0/24"


  tags = merge(
    var.tags, 
    {
      Name = "Time-Private-subnet"
      
    }
  )

  # tags = {
  #       Name = "${var.Project_name}-private-subnet"
  #       Terraform = true
  #       Environment = "Dev"
  # }
}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.vpc.id

    tags = merge(
      var.tags,
      {
        Name = "Time-private-route-table"
      }
    )

  # tags = {
  #       Name = "${var.Project_name}-private-route-table"
  #       Terraform = true
  #       Environment = "Dev"
 # }


}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.Private.id
  route_table_id = aws_route_table.private.id
}



resource "aws_subnet" "database" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.13.0/24"


  tags = merge(
      var.tags,
      {
        Name = "Time-database-subnet"
      }
    )

  # tags = {
  #       Name = "${var.Project_name}-database-subnet"
  #       Terraform = true
  #       Environment = "Dev"
 # }
}

resource "aws_route_table" "database" {
    vpc_id = aws_vpc.vpc.id


    tags = merge(
      var.tags,
      {
        Name = "Time-database-route-table"
      }
    )

  # tags = {
  #       Name = "${var.Project_name}-database-route-table"
  #       Terraform = true
  #       Environment = "Dev"
  #}


}

resource "aws_route_table_association" "database" {
  subnet_id      = aws_subnet.database.id
  route_table_id = aws_route_table.database.id
}


resource "aws_eip" "eip_nat" {
  vpc      = true
}


resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip_nat.id
  subnet_id     = aws_subnet.Public.id

  tags = merge(
      var.tags,
      {
        Name = "Time-Natgateway"
      }
    )

  # tags = {
  #   Name = "${var.Project_name}-Natgateway"
  #       Terraform = true
  #       Environment = "Dev"
  # }
}


resource "aws_route" "private" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
 nat_gateway_id = aws_nat_gateway.nat.id
 # depends_on                = [aws_route_table.private_rt]
}


resource "aws_route" "database" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
 nat_gateway_id = aws_nat_gateway.nat.id
 # depends_on                = [aws_route_table.database_rt]
}
