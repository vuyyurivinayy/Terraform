resource "aws_vpc" "one" {
tags = {
Name = "new-vpc"
}
cidr_block = "10.0.0.0/16"
instance_tenancy = "default"
enable_dns_hostnames = "true"
}

resource "aws_subnet" "public_subnet" {
vpc_id = aws_vpc.one.id
tags = {
Name = "public-subnet"
}
availability_zone = "us-east-1a"
cidr_block = "10.0.1.0/24"
map_public_ip_on_launch = "true"
}

resource "aws_internet_gateway" "igw" {
tags = {
Name = "tf-igw"
}
vpc_id = aws_vpc.one.id
}

resource "aws_route_table" "myrt" {
tags = {
Name = "tf-rt"
}
vpc_id = aws_vpc.one.id
route {
cidr_block = "0.0.0.0/0"
gateway_id = aws_internet_gateway.igw.id
}
}

resource "aws_route_table_association" "subnet-ass" {
subnet_id = aws_subnet.public_subnet.id
route_table_id = aws_route_table.myrt.id
}

resource "aws_subnet" "private_subnet" {
vpc_id = aws_vpc.one.id
tags = {
Name = "private-subnet"
}
availability_zone = "us-east-1b"
cidr_block = "10.0.2.0/24"
}

resource "aws_eip" "elasticIP" {
vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
allocation_id = aws_eip.elasticIP.id
subnet_id = aws_subnet.public_subnet.id

tags = {
Name = "nat-gtw"
}
}

resource "aws_route_table" "nated_route_table" {
vpc_id = aws_vpc.one.id
route {
cidr_block = "0.0.0.0/0"
nat_gateway_id = aws_nat_gateway.nat_gateway.id
}
tags = {
Name = "nated-rt"
}
}

resource "aws_route_table_association" "private_subnet_ass" {
subnet_id = aws_subnet.public_subnet.id
route_table_id = aws_route_table.nated_route_table.id
}

resource "aws_route_table" "private_subnet_rt" {
vpc_id = aws_vpc.one.id
tags = {
Name = "tf-prt"
}
}

resource "aws_route_table_association" "private" {
subnet_id = aws_subnet.private_subnet.id
route_table_id = aws_route_table.private_subnet_rt.id
}
